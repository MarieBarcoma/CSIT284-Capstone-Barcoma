import 'package:flutter_test/flutter_test.dart';
import 'package:capstone_barcoma/models/visit_repository.dart';

void main() {
  test('logging a visit puts it in the waiting queue', () async {
    final repo = InMemoryVisitRepository();
    await repo.addVisit(
      studentId: '21-0000-001',
      studentName: 'Test Student',
      symptom: 'Headache',
    );

    final queue = await repo.watchWaiting().first;
    expect(queue.length, 1);
    expect(queue.first.studentName, 'Test Student');
  });

  test('marking attended removes it from the queue', () async {
    final repo = InMemoryVisitRepository();
    await repo.addVisit(
      studentId: '21-0000-001',
      studentName: 'Test Student',
      symptom: 'Fever',
    );
    final id = (await repo.watchWaiting().first).first.id;

    await repo.markAttended(id);

    expect(await repo.watchWaiting().first, isEmpty);
    expect((await repo.watchAttendedToday().first).length, 1);
  });
}
