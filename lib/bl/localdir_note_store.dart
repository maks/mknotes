import 'dart:io';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart' as path;

import 'filters.dart';
import 'note.dart';
import 'note_store.dart';

/// Interface for Stores that provide access to notes.
class LocalDirNoteStore implements NoteStore {
  final Directory notesDir;

  final _notesListStream = BehaviorSubject<List<Note>>();

  LocalDirNoteStore({@required this.notesDir}) {
    final notesListStream = notesDir.list();

    notesListStream
        .asyncMap(
      (f) async => Note(
        filename: path.basename(f.absolute.path),
        title:
            path.basenameWithoutExtension(f.absolute.path).replaceAll('_', ' '),
        content: await _safeReadFile(f as File),
      ),
    )
        .scan<List<Note>>(
            (accumulated, value, index) => accumulated..add(value), []).forEach(
      (notes) {
        _notesListStream.add(notes);
      },
    );
  }

  Stream<List<Note>> get notes => _notesListStream;

  Future<String> _safeReadFile(File f) async {
    var result;
    try {
      result = await f?.readAsString();
    } catch (e) {
      print('error reading file $f: $e');
      result = '';
    }
    return result;
  }

  @override
  void saveFile(String filename, String contents) {
    File(path.join(notesDir.path, filename)).writeAsString(contents);
  }

  @override
  void filter(Filter searchFilter) {}

  @override
  void dispose() {
    _notesListStream.close();
  }
}
