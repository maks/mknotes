import 'package:flutter_test/flutter_test.dart';
import 'package:mknotes/bl/filters.dart';
import 'package:mknotes/bl/note.dart';

void main() {
  testWidgets('filter finds match no match in note title or content',
      (tester) async {
    final filter = SearchFilter('foo');
    final testNote = Note(filename: 'test.md', content: 'nothing really.');

    expect(filter.apply(testNote), false);
  });
  testWidgets('filter finds match in note title', (tester) async {
    final filter = SearchFilter('test');
    final testNote = Note(filename: 'test.md', content: 'nothing really.');

    expect(filter.apply(testNote), true);
  });
  testWidgets('filter finds match from partial in note content',
      (tester) async {
    final filter = SearchFilter('real');
    final testNote = Note(filename: 'test.md', content: 'nothing really.');

    expect(filter.apply(testNote), true);
  });
}
