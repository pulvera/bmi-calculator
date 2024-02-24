import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BMISavedHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI History'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
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

    // Sort history by date
    bmiHistory.sort((a, b) => b['dateTime']!.compareTo(a['dateTime']!));

    return bmiHistory;
  }
}