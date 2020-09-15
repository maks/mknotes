import 'dart:io';

import 'package:fake_async/fake_async.dart';
import 'package:mknotes/bl/item.dart';
import 'package:mknotes/bl/localdir_note_store.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  final mockDir = MockDir();

  setUp(() {
    final mockFile = MockFile();
    final mockAbsolute = MockFile();

    when(mockAbsolute.path).thenReturn('foo');
    when(mockFile.absolute).thenReturn(mockAbsolute);

    when(mockDir.list()).thenAnswer((realInvocation) => Stream.value(mockFile));
  });

  test('Local Dir returns list of file names', () async {
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
      List<ReferenceItem> notes;

      final store = LocalDirNoteStore(notesDir: mockDir);

      store.items.listen((nuNotes) {
        notes = nuNotes;
      });

      // need to get all events in the notes stream out before continuing
      async.flushMicrotasks();

      expect(notes.length, 1);
      expect(notes[0].title, 'foo');
    });
  });

  test('parse note content with NO yaml frontmatter', () async {
    final content = r'''a test
''';
    final store = LocalDirNoteStore(notesDir: mockDir);
    final note = await store.parseNoteText('test', 'a test', content);

    expect(note.tags.length, 0);
  });

  test('parse note content with yaml frontmatter', () async {
    final content = r'''---
tags: ['foo', 'bar']
---
a test
''';
    final store = LocalDirNoteStore(notesDir: mockDir);
    final note = await store.parseNoteText('test', 'a test', content);

    expect(note.tags.length, 2);
    expect(note.tags.contains('foo'), true);
    expect(note.tags.contains('bar'), true);
  });

  test('parse note content with empty yaml frontmatter', () async {
    final content = r'''---
---
a test
''';
    final store = LocalDirNoteStore(notesDir: mockDir);
    final note = await store.parseNoteText('test', 'a test', content);

    expect(note.tags.length, 0);
  });
}

class MockDir extends Mock implements Directory {}

class MockFile extends Mock implements File {}
