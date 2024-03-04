import 'dart:math';
import 'package:flutter/material.dart';
import 'bmi_saved_history.dart';
import 'bmi_utils.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
      debugShowCheckedModeBanner: false,
      home: const BMICalculator(),
    );
  }
}

class BMICalculator extends StatefulWidget {
  const BMICalculator({Key? key}) : super(key: key);

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  double bmiResult = 0.0;
  String bmiCategory = '';
  String selectedGender = 'Male'; // Default to Male
  bool showIdealWeight = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BMISavedHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Gender:'),
                    DropdownButton<String>(
                      value: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                      items: ['Male', 'Female'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: showIdealWeight,
                          onChanged: (value) {
                            setState(() {
                              showIdealWeight = value!;
                            });
                          },
                        ),
                        const Text('Show Ideal Weight'),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        calculateBMI();
                        saveBMI();
                      },
                      child: const Text('Calculate BMI'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text('BMI Result: ${bmiResult.toStringAsFixed(2)}'),
                Text('Category: $bmiCategory'),
                if (showIdealWeight) Text(
                    'Ideal Weight: ${calculateIdealWeight().toStringAsFixed(
                        2)} kg'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveBMI() async {
    try {
      DateTime now = DateTime.now();
      String currentDay = DateFormat("MMMM, dd, yyyy").format(DateTime.now());
      String cTime = DateFormat("hh:mm a").format(DateTime.now());
      String currentTime = currentDay + "  " + cTime;
      await ApiProvider().saveBMI(bmiResult, bmiCategory,currentTime);
      print('BMI data saved successfully');
    } catch (e) {
      print('Error in saving BMI data: $e');
    }
  }

  void calculateBMI() {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double heightInCm = double.tryParse(heightController.text) ?? 0.0;
    double heightInM = heightInCm / 100;

    if (weight > 0 && heightInCm > 0) {
      setState(() {
        bmiResult = calculateBMIValue(weight, heightInM);
        bmiCategory = interpretBMI(bmiResult);
      });
    }
  }

  double calculateBMIValue(double weight, double height) {
    return weight / (height * height);
  }

  double calculateIdealWeight() {
    // Assuming target BMI within the normal range is 22.5
    double targetBMI = 22.5;
    double idealWeight = targetBMI * (heightController.text.isNotEmpty ? pow(
        (double.parse(heightController.text) / 100), 2) : 0.0);
    return idealWeight;
  }

  String interpretBMI(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi >= 18.5 && bmi < 25) {
      return "Normal weight";
    } else if (bmi >= 25 && bmi < 30) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }
}
