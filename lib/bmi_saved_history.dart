import 'package:flutter/material.dart';
import 'bmi_utils.dart';

class BMISavedHistoryScreen extends StatelessWidget {
  final ApiProvider apiProvider = ApiProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: apiProvider.getSavedHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No BMI history available.'));
          } else {
            List<Map<String, dynamic>> bmiHistory = snapshot.data!;
            return ListView.builder(
              itemCount: bmiHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('BMI: ${bmiHistory[index]['bmi']}'),
                  subtitle: Text('Category: ${bmiHistory[index]['category']}'),
                  trailing: Text('Date: ${bmiHistory[index]['currentTime']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

