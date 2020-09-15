import 'package:mknotes/bl/item.dart';

import 'filters.dart';
import 'note.dart';

/// Interface for Stores that provide access to notes.
abstract class NoteStore {
  Stream<List<ReferenceItem>> get items;

  /// Add note to store
  void addNote(Note note);

  void updateNote(Note old, Note nue);

  /// Save note file with new contents
  void saveNote(Note note);

  /// Apply a filter to the list of notes returned by this store
  void filter(Filter filter) {}

  /// Dispose of the Store, allowing it to clean up any resources it is using
  void dispose();
}
