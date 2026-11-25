import 'dart:async';
import 'package:capstone_barcoma/models/visit.dart';
import 'package:capstone_barcoma/data/dummy_data.dart';

abstract class VisitRepository {
  Stream<List<Visit>> watchWaiting();
  Stream<List<Visit>> watchAttendedToday();
  Stream<List<Visit>> watchByStudent(String studentId);

  Future<void> addVisit({
    required String studentId,
    required String studentName,
    required String symptom,
    String note,
  });

  Future<void> markAttended(String visitId);
  Future<void> cancelVisit(String visitId);
}

class InMemoryVisitRepository implements VisitRepository {
  InMemoryVisitRepository([List<Visit> initial = const []]) : _visits = [...initial];

  factory InMemoryVisitRepository.seeded() => InMemoryVisitRepository(buildSeedVisits());

  final List<Visit> _visits;
  final StreamController<void> _changes = StreamController<void>.broadcast();
  int _nextId = 1000;

  Stream<List<Visit>> _watch(List<Visit> Function() query) async* {
    yield query();
    await for (final _ in _changes.stream) {
      yield query();
    }
  }

  void _notifyListeners() => _changes.add(null);

  @override
  Stream<List<Visit>> watchWaiting() => _watch(() {
    return _visits.where((v) => v.isWaiting).toList() ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  });

  @override
  Stream<List<Visit>> watchAttendedToday() => _watch(() {
    final now = DateTime.now();
    return _visits
    .where((v) => !v.isWaiting && v.attendedAt != null && _isSameDay(v.attendedAt!, now))
    .toList()..sort((a, b) => b.attendedAt!.compareTo(a.attendedAt!));
  });

  @override
  Stream<List<Visit>> watchByStudent(String studentId) => _watch(() {
    final id = studentId.trim();
    return _visits.where((v) => v.studentId == id).toList() ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  });

  @override
  Future<void> addVisit({
    required String studentId,
    required String studentName,
    required String symptom,
    String note = '',
  }) async {
    _visits.add(Visit(
      id: 'v${_nextId++}',
      studentId: studentId,
      studentName: studentName,
      symptom: symptom,
      note: note,
      timestamp: DateTime.now(),
    ));
    _notifyListeners();
  }

  @override
  Future<void> markAttended(String visitId) async {
    final index = _visits.indexWhere((v) => v.id == visitId);
    if (index == -1) return;
    _visits[index] = _visits[index].markAttended(DateTime.now());
    _notifyListeners();
  }

  @override
  Future<void> cancelVisit(String visitId) async {
    _visits.removeWhere((v) => v.id == visitId && v.isWaiting);
    _notifyListeners();
  }
}

bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
