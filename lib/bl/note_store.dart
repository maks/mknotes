import 'note.dart';

/// Interface for Stores that provide access to notes.
abstract class NoteStore {
  Stream<List<Note>> get notes;

  void saveFile(String filename, String contents);
}
