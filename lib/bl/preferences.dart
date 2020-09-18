import 'package:preferences/preferences.dart';

const String DOCS_DIR_PREF = "docs_dir";
const String PINBOARD_TOKEN_PREF = "pinboard_token";

class Preferences {
  String get docsDir => PrefService.getString(DOCS_DIR_PREF) ?? './docs';
  String get pinboardUser =>
      PrefService.getString(PINBOARD_TOKEN_PREF).split(":")[0];
  String get pinboardToken =>
      PrefService.getString(PINBOARD_TOKEN_PREF).split(":")[1];
}
