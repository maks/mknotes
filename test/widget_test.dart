import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mknotes/main.dart';
import 'package:mknotes/models/note.dart';
import 'package:mknotes/providers.dart';

void main() {
  testWidgets('current note has expected default title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: App()));

    expect(find.text(nuNoteTitle), findsOneWidget);
  });

  testWidgets('editing current note stores in datastore', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: App()));

    const testText = "test text";
    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), testText);

    final ref = tester.element<ConsumerStatefulElement>(find.byType(MainScreen));
    final dataStore = ref.read(dataStoreProvider);
    expect(dataStore.notes[nuNoteFilename]?.content, testText);
  });
}
