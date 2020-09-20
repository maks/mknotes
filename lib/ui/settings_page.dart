import 'package:file_chooser/file_chooser.dart';
import 'package:mknotes/bl/app_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:mknotes/extensions.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: SettingsList(
          sections: [
            SettingsSection(
              title: "General",
              tiles: [
                SettingsTile(
                  title: "Notes Path",
                  subtitle: "${appState.notesDir}",
                  onTap: () => _getNotesPath(appState),
                ),
              ],
            ),
            SettingsSection(
              title: "Pinboard",
              tiles: [
                SettingsTile(
                  title: "Token",
                  subtitle: "[${appState.pinboardUserAndToken}]",
                  leading: Icon(Icons.bookmark),
                  onTap: () => _showTokenEntryDialog(context, appState),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _getNotesPath(AppState state) async {
    final result = await showOpenPanel(
      canSelectDirectories: true,
      initialDirectory: state.notesDir,
    );
    if (!result.canceled) {
      state.notesDir = result.paths[0];
      setState(() {});
    }
  }

  void _showTokenEntryDialog(BuildContext context, AppState state) async {
    final textController = TextEditingController();
    final nuToken = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Token'),
        content: TextField(
          controller: textController..text = state.pinboardUserAndToken,
          decoration: InputDecoration(
            hintText: 'user:token',
            labelText: "Pinboard Token",
          ),
          maxLines: 1,
          onSubmitted: (token) {
            Navigator.pop(context, token);
          },
        ),
        actions: [
          FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("Ok"),
            onPressed: () {
              Navigator.pop(context, textController.text);
            },
          ),
        ],
      ),
    );
    if (nuToken.isNotNullOrEmpty) {
      state.pinboardUserAndToken = nuToken;
      setState(() {});
    }
  }
}
