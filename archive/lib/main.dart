import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mknotes/ui/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_size/window_size.dart';

import 'bl/app_state.dart';
import 'bl/localdir_note_store.dart';
import 'bl/pinboard_bookmarks.dart';
import 'bl/preferences.dart';
import 'extensions.dart';
import 'logging.dart';
import 'ui/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('mknotes');
    setWindowFrame(Rect.fromLTRB(1139.0, 517.0, 1861.0, 1125.0));
    _windowInfo();
  }
  runApp(
    MyApp(sharedPrefs: await SharedPreferences.getInstance()),
  );
}

void _windowInfo() async {
  final window = await getWindowInfo();
  Log().debug("initial window size: ${window.frame}");
}

class MyApp extends StatelessWidget {
  final String appName = 'MkNotes';
  final Preferences prefs;

  MyApp({Key key, SharedPreferences sharedPrefs})
      : prefs = Preferences(sharedPrefs),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final notesDir = Directory(prefs.docsDir);
    final localStore = LocalDirNoteStore(notesDir: notesDir);
    // Cant use pinboard for notes for now due to missing APIs
    // final pinboardStore = PinboardNoteStore(
    //   username: prefs.pinboardUser,
    //   token: prefs.pinboardToken,
    // );
    final bookmarks = prefs.usePinboard
        ? PinboardBookmarks(
            username: prefs.pinboardUser,
            token: prefs.pinboardToken,
            cacheDir: notesDir,
          )
        : null;
    final appState = AppState(localStore, bookmarks, prefs);
    if (bookmarks.isNotNull) {
      appState.loadBookmarks();
    }

    return ChangeNotifierProvider.value(
      value: appState,
      builder: (_, _2) => MaterialApp(
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          "/": (_) => MainPage(title: appName),
          "/settings": (_) => SettingsPage(),
        },
      ),
    );
  }
}
