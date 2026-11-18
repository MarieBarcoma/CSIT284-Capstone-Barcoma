import 'package:flutter/material.dart';


void main() {
  // Week 2: initialize Firebase here before runApp.
  runApp(const ClinicVisitLogApp());
}

class ClinicVisitLogApp extends StatelessWidget {
  const ClinicVisitLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clinic Visit Log',
      debugShowCheckedModeBanner: false,
      // Plain Material 3 defaults, just a seed color.
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const HomeShell(),
    );
  }
}
