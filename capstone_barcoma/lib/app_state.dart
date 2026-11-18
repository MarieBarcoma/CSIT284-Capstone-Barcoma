import 'package:flutter/foundation.dart';

import 'data/visit_repository.dart';

/// The one data source the whole app uses.
/// Week 2: replace with `FirestoreVisitRepository()`.
final VisitRepository visitRepo = InMemoryVisitRepository.seeded();

/// The student ID used on this phone (set after logging a visit),
/// so "My Visits" knows whose history to show. No login needed.
final ValueNotifier<String?> currentStudentId = ValueNotifier<String?>(null);

/// Hardcoded PIN for the hidden nurse screen (long-press the app title).
const String nursePin = '1234';
