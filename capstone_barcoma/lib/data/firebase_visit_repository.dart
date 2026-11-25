import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:capstone_barcoma/data/dummy_data.dart';
import 'package:capstone_barcoma/models/visit.dart';
import 'package:capstone_barcoma/models/visit_repository.dart';


class FirebaseVisitRepository implements VisitRepository {
  FirebaseVisitRepository({http.Client? client}) : _client = client ?? http.Client();

  static const String baseUrl = 'https://capstone---clinic-visit-4821e-default-rtdb.asia-southeast1.firebasedatabase.app';

  static const Duration refreshEvery = Duration(seconds: 5);

  final http.Client _client;

  final StreamController<void> _changes = StreamController<void>.broadcast();

  Uri _url(String path) => Uri.parse('$baseUrl/$path.json');

  void _check(http.Response res) {
    if (res.statusCode >= 400) {
      throw Exception('Firebase error ${res.statusCode}: ${res.body}');
    }
  }

  static Visit _fromJson(String id, Map<String, dynamic> json) {
    final attendedAt = json['attendedAt'] as String?;
    return Visit(
      id: id,
      studentId: json['studentId'] as String? ?? '',
      studentName: json['studentName'] as String? ?? '',
      symptom: json['symptom'] as String? ?? '',
      note: json['note'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
        DateTime.now(),
      status: json['status'] == 'attended'
        ? VisitStatus.attended
        : VisitStatus.waiting,
      attendedAt: attendedAt == null ? null : DateTime.tryParse(attendedAt),
    );
  }

  static Map<String, dynamic> _toJson(Visit v) => {
    'studentId': v.studentId,
    'studentName': v.studentName,
    'symptom': v.symptom,
    'note': v.note,
    'timestamp': v.timestamp.toIso8601String(),
    'status': v.status.name,
    'attendedAt': v.attendedAt?.toIso8601String(),
  };

  Future<List<Visit>> fetchAll() async {
    final res = await _client.get(_url('visits'));
    _check(res);

    final body = jsonDecode(res.body);
    if (body == null) return [];

    final map = body as Map<String, dynamic>;
    return map.entries
      .map((e) => _fromJson(e.key, e.value as Map<String, dynamic>))
      .toList();
  }

  Stream<List<Visit>> _watch(List<Visit> Function(List<Visit> all) query) {
    late final StreamController<List<Visit>> controller;
    StreamSubscription<void>? changesSub;
    Timer? timer;

    Future<void> refresh() async {
      try {
        final all = await fetchAll();
        if (!controller.isClosed) controller.add(query(all));
      } catch (e) {
        if (!controller.isClosed) controller.addError(e);
      }
    }

    controller = StreamController<List<Visit>>(
      onListen: () {
        refresh();
        changesSub = _changes.stream.listen((_) => refresh());
        timer = Timer.periodic(refreshEvery, (_) => refresh());
      },
      onCancel: () {
        changesSub?.cancel();
        timer?.cancel();
      },
    );
    return controller.stream;
  }

  @override
  Stream<List<Visit>> watchWaiting() => _watch((all) {
    return all.where((v) => v.isWaiting).toList()
    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  });

  @override
  Stream<List<Visit>> watchAttendedToday() => _watch((all) {
    final now = DateTime.now();
    return all
    .where((v) =>
    !v.isWaiting &&
    v.attendedAt != null && _isSameDay(v.attendedAt!, now))
    .toList()
    ..sort((a, b) => b.attendedAt!.compareTo(a.attendedAt!));
  });

  @override
  Stream<List<Visit>> watchByStudent(String studentId) => _watch((all) {
  final id = studentId.trim();
  return all.where((v) => v.studentId == id).toList()
  ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  });

  @override
  Future<void> addVisit({
    required String studentId,
    required String studentName,
    required String symptom,
    String note = '',
  }) async {
    final res = await _client.post(
    _url('visits'),
    body: jsonEncode({
      'studentId': studentId,
      'studentName': studentName,
      'symptom': symptom,
      'note': note,
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'waiting',
      'attendedAt': null,
    }),
    );
    _check(res);
    _changes.add(null);
  }

  @override
  Future<void> markAttended(String visitId) async {
    final res = await _client.patch(
      _url('visits/$visitId'),
      body: jsonEncode({
        'status': 'attended',
        'attendedAt': DateTime.now().toIso8601String(),
      }),
    );
    _check(res);
    _changes.add(null);
  }


  @override
  Future<void> cancelVisit(String visitId) async {
    final res = await _client.delete(_url('visits/$visitId'));
    _check(res);
    _changes.add(null);
  }

  Future<void> seedIfEmpty() async {
    if ((await fetchAll()).isNotEmpty) return;

    final data = {for (final v in buildSeedVisits()) v.id: _toJson(v)};
    final res = await _client.patch(_url('visits'), body: jsonEncode(data));
    _check(res);
  }
}

bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;