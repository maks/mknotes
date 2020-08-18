import 'package:flutter/material.dart';

import 'note.dart';

class AppState extends ChangeNotifier {
  Note _current;
  bool _edit = false;

  Note get current => _current;

  set current(Note n) {
    _current = n;
    notifyListeners();
  }

  get edit => _edit;

  toggleEdit() {
    _edit = !_edit;
    notifyListeners();
  }

  /// update WITHOUT notifying listeners, useful as textfields maintain their own
  /// state of the text so we don't want to keep rebuilding them as the content is edited
  /// due to them listening to changes to the app state
  updateCurrentContent(String text) {
    _current = _current.copyWith(content: text);
  }
}
