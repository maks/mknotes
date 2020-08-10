import 'dart:io';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'note.dart';
import 'note_store.dart';

/// Interface for Stores that provide access to notes.
class LocalDirNoteStore implements NoteStore {
  final String path;

  LocalDirNoteStore({@required this.path});

  Stream<List<Note>> get notes {
    final notesDir = Directory(path);

    final notesListStream = notesDir.list();

    return notesListStream
        .map((f) => Note(name: f.absolute.path, content: ''))
        .scan((accumulated, value, index) => accumulated..add(value), []);
  }
}
