import 'dart:io';

import 'package:maksnotes/bl/localdir_note_store.dart';
import 'package:maksnotes/bl/note.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  test('Local Dir returns list of file names', () async {
    final mockDir = MockDir();
    when(mockDir.list())
        .thenAnswer((realInvocation) => Stream.value(File('foo')));

    final store = LocalDirNoteStore(notesDir: mockDir);

    // store returns a stream of Lists of Notes so need
    // to await until we get first event out of the stream
    List<Note> notes = await store.notes.first;

    expect(notes.length, 1);
    expect(notes[0].name, 'foo');
  });
}

class MockDir extends Mock implements Directory {}
