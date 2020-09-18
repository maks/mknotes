import 'package:preferences/preferences.dart';

const String _DOCS_DIR_PREF = "docs_dir";
const String _PINBOARD_USER_PREF = "pinboard_user";
const String _PINBOARD_TOKEN_PREF = "pinboard_token";

class Preferences {
  String get docsDir => PrefService.getString(_DOCS_DIR_PREF) ?? './docs';
  String get pinboardUser => PrefService.getString(_PINBOARD_USER_PREF);
  String get pinboardToken => PrefService.getString(_PINBOARD_TOKEN_PREF);
}
