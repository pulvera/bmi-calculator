import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveBMI(double bmiResult, String bmiCategory) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  DateTime now = DateTime.now();
  String currentDate = "${now.year}-${now.month}-${now.day}";
  String currentTime = "${now.hour}:${now.minute}:${now.second}";
  String dateTime = "$currentDate $currentTime";

  prefs.setString('bmi_$dateTime', bmiResult.toString());
  prefs.setString('category_$dateTime', bmiCategory);
  prefs.setString('dateTime_$dateTime', dateTime);
}
