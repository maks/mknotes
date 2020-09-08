import 'package:mknotes/bl/note.dart';
import 'package:test/test.dart';

void main() {
  test('create a note from content with single short line', () async {
    final content = 'this is a test';
    final testNote = Note.untitled(content);

    expect(testNote.name, 'untitled');

    expect(testNote.filename, 'untitled.md');

    expect(testNote.content, content);
  });
  test('create a note from content with punctuation on first line', () async {
    final content = '<this ?is,] a test>';
    final testNote = Note.untitled(content).copyWith(title: content);

    expect(testNote.name, 'this is a test');

    expect(testNote.filename, 'this_is_a_test.md');

    expect(testNote.content, content);
  });
  test('create a note from content with multiple lines', () async {
    final content = 'this is a\n test.';
    final testNote = Note.untitled(content);

    expect(testNote.name, 'untitled');

    expect(testNote.filename, 'untitled.md');

    expect(testNote.content, content);
  });
}
