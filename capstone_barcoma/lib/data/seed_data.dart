import 'package:capstone_barcoma/models/visit.dart';

const List<String> symptoms = [
  'Headache',
  'Fever',
  'Stomachache',
  'Dizziness',
  'Cough / Colds',
  'Minor injury',
  'Menstrual cramps',
  'Other',
];

List<Visit> buildSeedVisits() {
  final now = DateTime.now();
  DateTime minutesAgo(int m) => now.subtract(Duration(minutes: m));
  DateTime daysAgo(int d, {int plusMinutes = 0}) =>
      now.subtract(Duration(days: d)).add(Duration(minutes: plusMinutes));

  return [
    Visit(
      id: 'v1',
      studentId: '22-0451-118',
      studentName: 'Ana Reyes',
      symptom: 'Headache',
      note: 'Since 2nd period',
      timestamp: minutesAgo(25),
    ),
    Visit(
      id: 'v2',
      studentId: '23-1102-334',
      studentName: 'Miguel Santos',
      symptom: 'Minor injury',
      note: 'Scraped knee during PE',
      timestamp: minutesAgo(18),
    ),
    Visit(
      id: 'v3',
      studentId: '21-0987-552',
      studentName: 'Joy Villanueva',
      symptom: 'Dizziness',
      timestamp: minutesAgo(11),
    ),
    Visit(
      id: 'v4',
      studentId: '24-0213-469',
      studentName: 'Paolo Garcia',
      symptom: 'Fever',
      note: 'Felt hot after lunch',
      timestamp: minutesAgo(7),
    ),
    Visit(
      id: 'v5',
      studentId: '23-0778-905',
      studentName: 'Bea Lim',
      symptom: 'Menstrual cramps',
      timestamp: minutesAgo(3),
    ),


    Visit(
      id: 'v6',
      studentId: '22-3310-207',
      studentName: 'Carlo Mendoza',
      symptom: 'Fever',
      timestamp: minutesAgo(95),
      status: VisitStatus.attended,
      attendedAt: minutesAgo(80),
    ),
    Visit(
      id: 'v7',
      studentId: '21-1234-567',
      studentName: 'Demo Student',
      symptom: 'Stomachache',
      timestamp: minutesAgo(150),
      status: VisitStatus.attended,
      attendedAt: minutesAgo(140),
    ),
    Visit(
      id: 'v8',
      studentId: '24-1189-031',
      studentName: 'Kyla Fernandez',
      symptom: 'Cough / Colds',
      timestamp: minutesAgo(70),
      status: VisitStatus.attended,
      attendedAt: minutesAgo(60),
    ),
    Visit(
      id: 'v9',
      studentId: '22-2045-612',
      studentName: 'Rafael Dela Cruz',
      symptom: 'Minor injury',
      note: 'Paper cut, needs bandage',
      timestamp: minutesAgo(45),
      status: VisitStatus.attended,
      attendedAt: minutesAgo(40),
    ),

    Visit(
      id: 'v10',
      studentId: '21-1234-567',
      studentName: 'Demo Student',
      symptom: 'Cough / Colds',
      timestamp: daysAgo(6),
      status: VisitStatus.attended,
      attendedAt: daysAgo(6, plusMinutes: 10),
    ),
    Visit(
      id: 'v11',
      studentId: '21-1234-567',
      studentName: 'Demo Student',
      symptom: 'Headache',
      note: 'Skipped breakfast',
      timestamp: daysAgo(13),
      status: VisitStatus.attended,
      attendedAt: daysAgo(13, plusMinutes: 15),
    ),
    Visit(
      id: 'v12',
      studentId: '23-1102-334',
      studentName: 'Miguel Santos',
      symptom: 'Dizziness',
      timestamp: daysAgo(3),
      status: VisitStatus.attended,
      attendedAt: daysAgo(3, plusMinutes: 8),
    ),
  ];
}