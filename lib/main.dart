import 'package:flutter/material.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Student Information',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue[900],
        ),
        backgroundColor: Colors.white,
        body: const Center(
          child: StudentInfoScreen(),
        ),
      ),
    );
  }
}

class StudentInfoScreen extends StatefulWidget {
  const StudentInfoScreen({super.key});

  @override
  State<StudentInfoScreen> createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  String name = 'Chelsy Kate R. Pulvera';
  String birthdate = 'July 26, 2000';
  String course = 'BSIT-3R6';
  String email = 'pulverachelsyr@gmail.com';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 70.0,
            backgroundImage: AssetImage('assets/picture.jpg'),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Name: $name',
            style: const TextStyle(fontSize: 15.0),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Birthdate: $birthdate',
            style: const TextStyle(fontSize: 15.0),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Course & Section: $course',
            style: const TextStyle(fontSize: 15.0),
          ),
          const SizedBox(height: 10.0),
          Text(
            'E-mail: $email',
            style: const TextStyle(fontSize: 15.0),
          ),
        ],
      ),
    );
  }
}
