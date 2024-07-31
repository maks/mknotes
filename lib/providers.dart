import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localdir_note_store.dart';

final prefsProvider = FutureProvider((ref) => SharedPreferences.getInstance());

final notesStoreProvier = FutureProvider<LocalDirNoteStore>((ref) async {
  final prefs = await ref.watch(prefsProvider.future);
  final Directory notesDir = Directory(prefs.getString("docsDir") ?? ".");

  return LocalDirNoteStore(notesDir);
});
