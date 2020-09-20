import 'package:flutter/material.dart';
import 'package:mknotes/bl/bookmark.dart';
import 'package:mknotes/bl/pinboard_bookmarks.dart';
import 'package:mknotes/bl/preferences.dart';
import 'package:mknotes/bl/reference_item.dart';
import 'package:rxdart/rxdart.dart';

import '../extensions.dart';
import 'filters.dart';
import 'note.dart';
import 'note_store.dart';

class AppState extends ChangeNotifier {
  ReferenceItem _current;
  bool _edit = false;

  final PinboardBookmarks _bookmarks;
  final NoteStore _store;
  final Preferences prefs;
  String _currentSearchTerm;

  // tricky stuff here. Because _store & _bookmarks.items are actually streams
  // of LISTs of items, not streams of items, we need use combine rx operator
  // to get the latest list from each stream and then merge the 2 lists together
  // using the list spread operator
  Stream<List<ReferenceItem>> get allItems => _bookmarks.isNotNull
      ? Rx.combineLatest2<List<Note>, List<Bookmark>, List<ReferenceItem>>(
          _store.items,
          _bookmarks.items,
          (a, b) => <ReferenceItem>[...a, ...b]..sort(
              (c, d) => c.title.compareTo(d.title),
            ),
        )
      : _store.items;

  ReferenceItem get current => _current;

  String get searchTerm => _currentSearchTerm;

  set current(ReferenceItem n) {
    _current = n;
    notifyListeners();
  }

  bool get edit => _edit;

  String get notesDir => prefs.docsDir;

  set notesDir(String dir) {
    prefs.docsDir = dir;
    notifyListeners();
  }

  String get pinboardUserAndToken => prefs.pinboardUserAndToken;

  set pinboardUserAndToken(String token) {
    prefs.pinboardUserAndToken = token;
    notifyListeners();
  }

  AppState(this._store, this._bookmarks, this.prefs);

  void toggleEdit() {
    if (edit) {
      if (_current.isUntitled) {
        //FIXME: show an error UI to user instead of this
        throw Exception("notes need a title before they can be saved");
      }
      // if we were currently editing, save file before existing edit mode
      _saveCurrent();
    }
    _setEdit(!_edit);
  }

  /// update WITHOUT notifying listeners, useful as textfields maintain their own
  /// state of the text so we don't want to keep rebuilding them as the content is edited
  /// due to them listening to changes to the app state
  void updateCurrentContent(String text) {
    if (_current is Note) {
      final Note _curr = _current as Note;
      final Note old = _curr;
      _current = _curr.copyWith(content: text);
      _store.updateNote(old, _current as Note);
    }
  }

  void updateCurrentTitle(String title) {
    if (_current is Note) {
      final Note _curr = _current as Note;
      final old = _curr;
      _current = _curr.copyWith(title: title);
      _store.updateNote(old, _current as Note);
    }
  }

  void updateCurrentRemoveTag(String tag) {
    final old = _current;
    final updatedTags = _current.tags..remove(tag);
    _current = _current.copyWith(tags: updatedTags);
    //FIXME: need to handle updating bookmarks as well later on
    _store.updateNote(old as Note, _current as Note);
    notifyListeners();
  }

  void updateCurrentAddTag(String tag) {
    final old = _current;
    final updatedTags = _current.tags..add(tag);
    _current = _current.copyWith(tags: updatedTags);
    //FIXME: need to handle updating bookmarks as well later on
    _store.updateNote(old as Note, _current as Note);
    notifyListeners();
  }

  void search(String term) {
    _currentSearchTerm = term;
    _store
        .filter((term != null && term.isNotEmpty) ? SearchFilter(term) : null);
  }

  void newNote() {
    current = Note.untitled('new note');
    _store.addNote(current as Note);
    _setEdit(true);
  }

  void _setEdit(bool edit) {
    _edit = edit;
    notifyListeners();
  }

  void _saveCurrent() {
    _store.saveNote(_current as Note);
  }

  void loadBookmarks() {
    _bookmarks.load();
  }
}
