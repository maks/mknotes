import '../models/note.dart';

abstract class DataStore {
  Future<Note> load(String name);

  Future<void> store(Note note);
}

class InMemoryDataStore implements DataStore {
  final Map<String, Note> notes = {};

  @override
  Future<Note> load(String name) async {
    final note = notes[name];
    if (note == null) {
      throw Exception("no such note:$name");
    }
    return note;
  }

  @override
  Future<void> store(Note note) async {
    notes[note.filename] = note;
  }
}
