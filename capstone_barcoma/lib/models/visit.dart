enum VisitStatus { waiting, attended }

/// One clinic visit logged by a student.
/// Matches the Firestore document shape we'll use in Week 2.
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
  final DateTime timestamp; // when the student logged the visit
  final VisitStatus status;
  final DateTime? attendedAt; // null until the nurse marks it attended

  bool get isWaiting => status == VisitStatus.waiting;

  /// Returns a copy of this visit marked as attended.
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
