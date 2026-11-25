import 'package:flutter/material.dart';
import 'package:capstone_barcoma/screens/home_shell.dart';

void main() {
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