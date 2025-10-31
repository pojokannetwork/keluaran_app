import 'package:flutter_test/flutter_test.dart';
import 'package:keluaran_app/main.dart' as app;

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    app.main(); // builds the app and schedules a frame but doesn't trigger one
    await tester.pump(); // triggers a frame

    expect(find.text('Data Keluaran'), findsOneWidget);
  });
}
