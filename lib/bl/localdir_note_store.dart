import 'dart:io';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart' as path;

import 'note.dart';
import 'note_store.dart';

/// Interface for Stores that provide access to notes.
class LocalDirNoteStore implements NoteStore {
  final Directory notesDir;

  LocalDirNoteStore({@required this.notesDir});

  Stream<List<Note>> get notes {
    final notesListStream = notesDir.list();

    return notesListStream
        .map((f) => Note(
              name: path.basenameWithoutExtension(f.absolute.path),
              content: '',
            ))
        .scan((accumulated, value, index) => accumulated..add(value), []);
  }
}
