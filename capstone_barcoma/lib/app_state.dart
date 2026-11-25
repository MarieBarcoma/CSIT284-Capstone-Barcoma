import 'package:flutter/foundation.dart';

import 'package:capstone_barcoma/data/firebase_visit_repository.dart';
import 'package:capstone_barcoma/models/visit_repository.dart';

/// The one data source the whole app uses.
/// Day 2: Firebase Realtime Database through the http package.
/// (To go back to offline dummy data: InMemoryVisitRepository.seeded())
final VisitRepository visitRepo = FirebaseVisitRepository();

/// The student ID used on this phone (set after logging a visit),
/// so "My Visits" knows whose history to show. No login needed.
final ValueNotifier<String?> currentStudentId = ValueNotifier<String?>(null);

/// Hardcoded PIN for the hidden nurse screen (long-press the app title).
const String nursePin = '1234';