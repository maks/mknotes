import 'package:shared_preferences/shared_preferences.dart';

const String _DOCS_DIR_PREF = "docs_dir";
const String _PINBOARD_TOKEN_PREF = "pinboard_token";

class Preferences {
  final SharedPreferences prefs;

  Preferences(this.prefs);

  String get docsDir => prefs.getString(_DOCS_DIR_PREF) ?? './docs';
  set docsDir(String dir) => prefs.setString(_DOCS_DIR_PREF, dir);
  String get pinboardUserAndToken => prefs.getString(_PINBOARD_TOKEN_PREF);
  String get pinboardUser =>
      prefs.getString(_PINBOARD_TOKEN_PREF)?.split(":")?.elementAt(0);
  String get pinboardToken =>
      _safeSplit(prefs.getString(_PINBOARD_TOKEN_PREF), ":", 1);
  set pinboardUserAndToken(String token) =>
      prefs.setString(_PINBOARD_TOKEN_PREF, token);

  String _safeSplit(String s, String splitOn, int part) {
    final r = s.split(splitOn);
    if (r != null) {
      if (r.length > part) {
        return r[part];
      }
    }
  }
}
