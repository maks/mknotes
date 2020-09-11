import 'dart:io';

import 'package:fake_async/fake_async.dart';
import 'package:mknotes/bl/localdir_note_store.dart';
import 'package:mknotes/bl/note.dart';
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
    final notes = await store.items.first;

    expect(notes.length, 1);
    expect(notes[0].title, 'foo');
  });

  test('list of file names ignores dot-files', () async {
    final mockDir = MockDir();
    final mockFile = MockFile();
    final mockDotFile = MockFile();
    final mockAbsolute = MockFile();
    final mockDotAbsolute = MockFile();

    when(mockAbsolute.path).thenReturn('foo');
    when(mockFile.absolute).thenReturn(mockAbsolute);
    when(mockDotAbsolute.path).thenReturn('.foobar');
    when(mockDotFile.absolute).thenReturn(mockDotAbsolute);

    when(mockDir.list()).thenAnswer(
        (realInvocation) => Stream.fromIterable([mockFile, mockDotFile]));

    FakeAsync().run((async) {
      List<Note> notes;

      final store = LocalDirNoteStore(notesDir: mockDir);

      store.items.listen((nuNotes) {
        notes = nuNotes as List<Note>;
      });

      // need to get all events in the notes stream out before continuing
      async.flushMicrotasks();

      expect(notes.length, 1);
      expect(notes[0].title, 'foo');
    });
  });
}

class MockDir extends Mock implements Directory {}

class MockFile extends Mock implements File {}
