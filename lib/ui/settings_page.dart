import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:mknotes/bl/preferences.dart';
import 'package:preferences/preference_title.dart';
import 'package:preferences/preferences.dart';

import '../logging.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final path = PrefService.getString(DOCS_DIR_PREF);
    print("P: $path");
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PreferenceTitle('General'),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Notes Path: $path"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: MaterialButton(
                    child: Text("Browse..."),
                    onPressed: () => _getNotesPath(''),
                  ),
                )
              ],
            ),
            PreferenceTitle('Pinboard'),
            TextFieldPreference(
              'Token',
              PINBOARD_TOKEN_PREF,
            )
          ],
        ),
      ),
    );
  }

  void _getNotesPath(String current) async {
    final result = await showOpenPanel(
      canSelectDirectories: true,
      initialDirectory: current,
    );
    Log().debug("path: ${result.paths[0]}");
    await PrefService.setString(DOCS_DIR_PREF, result.paths[0]);
    setState(() {});
  }
}
