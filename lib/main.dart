import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                MaterialPageRoute(builder: (context) => BMISavedHistoryScreen()),
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
                if (showIdealWeight) Text('Ideal Weight: ${calculateIdealWeight().toStringAsFixed(2)} kg'),
              ],
            ),
          ),
        ),
      ),
    );
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
    double idealWeight = targetBMI * (heightController.text.isNotEmpty ? pow((double.parse(heightController.text) / 100), 2) : 0.0);
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

  Future<void> saveBMI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String currentDate = "${now.year}-${now.month}-${now.day}";
    String currentTime = "${now.hour}:${now.minute}:${now.second}";
    String dateTime = "$currentDate $currentTime";

    prefs.setString('bmi_$dateTime', bmiResult.toString());
    prefs.setString('category_$dateTime', bmiCategory);
    prefs.setString('dateTime_$dateTime', dateTime);
  }
}

class BMISavedHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI History'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        // Assuming 'bmi', 'category', and 'dateTime' are the keys you used in SharedPreferences
        future: getSavedBMIHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No BMI history available.'));
          } else {
            List<Map<String, String>> bmiHistory = snapshot.data!;
            return ListView.builder(
              itemCount: bmiHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('BMI: ${bmiHistory[index]['bmi']}'),
                  subtitle: Text('Category: ${bmiHistory[index]['category']}'),
                  trailing: Text('Date: ${bmiHistory[index]['dateTime']}'),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, String>>> getSavedBMIHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> bmiHistory = [];

    for (String key in prefs.getKeys()) {
      if (key.startsWith('bmi_')) {
        Map<String, String> bmiData = {
          'bmi': prefs.getString(key) ?? '',
          'category': prefs.getString(key.replaceFirst('bmi_', 'category_')) ?? '',
          'dateTime': prefs.getString(key.replaceFirst('bmi_', 'dateTime_')) ?? '',
        };
        bmiHistory.add(bmiData);
      }
    }

    // Sort the history by date
    bmiHistory.sort((a, b) => b['dateTime']!.compareTo(a['dateTime']!));

    return bmiHistory;
  }
}