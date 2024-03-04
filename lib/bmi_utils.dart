import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String baseUrl;

  ApiProvider({this.baseUrl = 'https://bmi-calculator-24576-default-rtdb.firebaseio.com/'});

  Future<void> saveBMI(double bmiResult, String bmiCategory, String currentTime) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bmi.json'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'bmi': bmiResult.toString(),
          'category': bmiCategory,
          'currentTime' : currentTime,
        }),
      );

      print('Save BMI Response Code: ${response.statusCode}');
      print('Save BMI Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('BMI data saved successfully');
      } else {
        throw Exception('Failed to save BMI data');
      }
    } catch (e) {
      print('Error in saveBMI: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSavedHistory() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bmi.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<Map<String, dynamic>> historyList = [];

        data.forEach((key, value) {
          historyList.add({
            'bmi': value['bmi'],
            'category': value['category'],
            'currentTime' : value['currentTime'],
            // Add other fields if needed
          });
        });

        return historyList;
      } else {
        throw Exception('Failed to load BMI history');
      }
    } catch (e) {
      print('Error in getSavedHistory: $e');
      return []; // Return an empty list if there's an error
    }
  }
}



