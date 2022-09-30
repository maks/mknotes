import 'package:flutter_test/flutter_test.dart';
import 'package:mknotes/bl/preferences.dart';

import 'package:mknotes/main.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, dynamic>{"_": '_'});
  });
  testWidgets('smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      sharedPrefs: await SharedPreferences.getInstance(),
    ));
    expect(find.text('MkNotes'), findsOneWidget);
  });
}

class MockPreferences extends Mock implements Preferences {}
