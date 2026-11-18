import 'package:flutter_test/flutter_test.dart';

import 'package:capstone_barcoma/main.dart';

void main() {
  testWidgets('app opens on the Log Visit form', (tester) async {
    await tester.pumpWidget(const ClinicVisitLogApp());

    expect(find.text('Clinic Visit Log'), findsOneWidget);
    expect(find.text('Submit visit'), findsOneWidget);
  });
}