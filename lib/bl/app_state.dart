import 'package:flutter/material.dart';
import 'filters.dart';
import 'note.dart';
import 'note_store.dart';

class AppState extends ChangeNotifier {
  Note _current;
  bool _edit = false;
  final NoteStore store;
  String _currentSearchTerm;

  Note get current => _current;

  String get searchTerm => _currentSearchTerm;

  set current(Note n) {
    _current = n;
    notifyListeners();
  }

  bool get edit => _edit;

  AppState(this.store);

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
    final old = _current;
    _current = _current.copyWith(content: text);
    store.updateNote(old, _current);
  }

  void updateCurrentTitle(String title) {
    final old = _current;
    _current = _current.copyWith(title: title);
    store.updateNote(old, _current);
  }

  void updateCurrentRemoveTag(String tag) {
    final old = _current;
    final updatedTags = _current.tags..remove(tag);
    _current = _current.copyWith(tags: updatedTags);
    store.updateNote(old, _current);
    notifyListeners();
  }

  void search(String term) {
    _currentSearchTerm = term;
    store.filter((term != null && term.isNotEmpty) ? SearchFilter(term) : null);
  }

  void newNote() {
    current = Note.untitled('new note');
    store.addNote(current);
    _setEdit(true);
  }

  void _setEdit(bool edit) {
    _edit = edit;
    notifyListeners();
  }

  void _saveCurrent() {
    store.saveNote(_current);
  }
}
