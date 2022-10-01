import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'datastores/datastore.dart';
import 'models/note.dart';

class CurrentNoteModel extends StateNotifier<Note> {
  final DataStore dataStore;

  CurrentNoteModel({required this.dataStore}) : super(Note.empty());

  Future<void> updateContent(String content) {
    state = state.copyWith(content: content);
    return dataStore.store(state);
  }
}
