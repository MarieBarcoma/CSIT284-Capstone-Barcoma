import 'package:flutter/material.dart';

import 'package:capstone_barcoma/app_state.dart';
import 'package:capstone_barcoma/data/firebase_visit_repository.dart';
import 'package:capstone_barcoma/screens/home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Put the 12 dummy visits into Firebase the first time the app runs.
  final repo = visitRepo;
  if (repo is FirebaseVisitRepository) {
    try {
      await repo.seedIfEmpty();
    } catch (e) {
      debugPrint('Could not seed Firebase: $e');
    }
  }

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