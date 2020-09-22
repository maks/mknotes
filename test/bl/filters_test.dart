import 'package:test/test.dart';
import 'package:mknotes/bl/filters.dart';
import 'package:mknotes/bl/note.dart';

void main() {
  test('filter finds match no match in note title or content', () async {
    final filter = SearchFilter('foo');
    final testNote =
        Note(id: 'test.md', content: 'nothing really.', title: 'test');

    expect(filter.apply(testNote), false);
  });
  test('filter finds match in note title', () async {
    final filter = SearchFilter('test');
    final testNote =
        Note(id: 'test.md', content: 'nothing really.', title: 'test');

    expect(filter.apply(testNote), true);
  });
  test('filter finds match from partial in note content', () async {
    final filter = SearchFilter('real');
    final testNote =
        Note(id: 'test.md', content: 'nothing really.', title: 'test');

    expect(filter.apply(testNote), true);
  });
}
