import 'filters.dart';
import 'note.dart';

/// Interface for Stores that provide access to notes.
abstract class NoteStore {
  Stream<List<Note>> get notes;

  /// Add note to store
  void addNote(Note note);

  /// Save note file with new contents
  void saveFile(String filename, String contents);

  /// Apply a filter to the list of notes returned by this store
  void filter(Filter filter) {}

  /// Dispose of the Store, allowing it to clean up any resources it is using
  void dispose();
}
