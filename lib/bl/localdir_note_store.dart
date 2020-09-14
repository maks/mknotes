import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mknotes/bl/bookmark.dart';
import 'package:mknotes/bl/item.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart' as path;

import 'filters.dart';
import 'note.dart';
import 'note_store.dart';

/// Interface for Stores that provide access to notes.
class LocalDirNoteStore implements NoteStore {
  final Directory notesDir;
  final _notesListStream = BehaviorSubject<List<ReferenceItem>>();
  List<ReferenceItem> _fullList;

  LocalDirNoteStore({@required this.notesDir}) {
    final notesListStream = notesDir.list();

    notesListStream
        .where((f) => !path.basename(f.absolute.path).startsWith('.'))
        .asyncMap(
          (f) async => Note(
            filename: path.basename(f.absolute.path),
            title: path
                .basenameWithoutExtension(f.absolute.path)
                .replaceAll('_', ' '),
            content: await _safeReadFile(f as File),
          ),
        )
        .scan<List<Note>>(
            (accumulated, value, index) => accumulated..add(value), []).forEach(
      (notes) {
        _notesListStream.add(notes);
        _fullList = notes;
      },
    );

    readBookmarksFile();
  }

  Future<List<Bookmark>> readBookmarksFile() async {
    final File bookmarksfile = File(path.join(notesDir.path, '.bookmarks'));
    if (bookmarksfile.existsSync()) {
      final bookmarksJson = await bookmarksfile.readAsString();

      final bookmarks = await parseBookmarksJson(bookmarksJson);
      print('booksmarks $bookmarks');
      return bookmarks;
    }
    return [];
  }

  @override
  Stream<List<ReferenceItem>> get items => _notesListStream;

  Future<String> _safeReadFile(File f) async {
    String result;
    try {
      result = await f?.readAsString();
    } catch (e) {
      print('error reading file $f: $e');
      result = '';
    }
    return result;
  }

  Future<List<Bookmark>> parseBookmarksJson(String json) async {
    final List<dynamic> parsed = jsonDecode(json) as List<dynamic>;

    return Future.value(parsed
        .map<Bookmark>((dynamic jsonMap) =>
            Bookmark.fromMap(jsonMap as Map<String, dynamic>))
        .toList());
  }

  @override
  void saveNote(Note note) {
    File(path.join(notesDir.path, note.filename)).writeAsString(note.content);
  }

  @override
  void filter(Filter filter) {
    if (filter == null) {
      _notesListStream.add(_fullList);
    } else {
      _notesListStream
          .add(_fullList.where((note) => filter.apply(note)).toList());
    }
  }

  @override
  void dispose() {
    _notesListStream.close();
  }

  @override
  void addNote(Note note) {
    _fullList.add(note);
    // FIXME: need to change this as it will clear any filter being currently applied
    _notesListStream.add(_fullList);
  }

  @override
  void updateNote(Note old, Note nue) {
    _fullList.remove(old);
    _fullList.add(nue);
    _notesListStream.add(_fullList);
  }
}
