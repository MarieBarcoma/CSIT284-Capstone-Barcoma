enum VisitStatus { waiting, attended }

class Visit {
  const Visit({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.symptom,
    required this.timestamp,
    this.note = '',
    this.status = VisitStatus.waiting,
    this.attendedAt,
  });

  final String id;
  final String studentId;
  final String studentName;
  final String symptom;
  final String note;
  final DateTime timestamp;
  final VisitStatus status;
  final DateTime? attendedAt;

  bool get isWaiting => status == VisitStatus.waiting;

  Visit markAttended(DateTime when) => Visit(
    id: id,
    studentId: studentId,
    studentName: studentName,
    symptom: symptom,
    timestamp: timestamp,
    note: note,
    status: VisitStatus.attended,
    attendedAt: when,
  );
}
