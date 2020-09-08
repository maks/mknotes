import 'dart:io';

import 'package:mknotes/bl/localdir_note_store.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  test('Local Dir returns list of file names', () async {
    final mockDir = MockDir();
    final mockFile = MockFile();
    final mockAbsolute = MockFile();

    when(mockAbsolute.path).thenReturn('foo');
    when(mockFile.absolute).thenReturn(mockAbsolute);

    when(mockDir.list()).thenAnswer((realInvocation) => Stream.value(mockFile));

    final store = LocalDirNoteStore(notesDir: mockDir);

    // store returns a stream of Lists of Notes so need
    // to await until we get first event out of the stream
    final notes = await store.notes.first;

    expect(notes.length, 1);
    expect(notes[0].name, 'foo');
  });
}

class MockDir extends Mock implements Directory {}

class MockFile extends Mock implements File {}
