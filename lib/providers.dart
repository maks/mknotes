import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'current_note_model.dart';
import 'datastores/datastore.dart';
import 'models/note.dart';

final dataStoreProvider = Provider((ref) => InMemoryDataStore());

final currentNoteModelProvider = StateNotifierProvider<CurrentNoteModel, Note>(
  (ref) => CurrentNoteModel(dataStore: ref.watch(dataStoreProvider)),
);
