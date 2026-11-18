import 'package:flutter/foundation.dart';

import 'package:capstone_barcoma/models/visit_repository.dart';

final VisitRepository visitRepo = InMemoryVisitRepository.seeded();

final ValueNotifier<String?> currentStudentId = ValueNotifier<String?>(null);

/// Hardcoded PIN for the hidden nurse screen (long-press the app title).
const String nursePin = '1234';
