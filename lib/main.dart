import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maksnotes/bl/localdir_note_store.dart';
import 'package:maksnotes/ui/list_widget.dart';
import 'package:provider/provider.dart';

import 'bl/app_state.dart';
import 'bl/note.dart';
import 'bl/note_store.dart';
import 'ui/note_widget.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String appName = 'Maks Notes';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(title: appName),
    );
  }
}

class MainPage extends StatefulWidget {
  final String title;

  MainPage({@required this.title});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final NoteStore _noteStore;
  final AppState appState;

  // need to use factory constructor trick to initialise dependent finals
  // ref: https://stackoverflow.com/a/52964776/85472
  _MainPageState._(this._noteStore, this.appState);

  factory _MainPageState() {
    final store = LocalDirNoteStore(notesDir: Directory('./docs'));
    return _MainPageState._(store, AppState(store));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appState,
      builder: (BuildContext context, _) => Scaffold(
        appBar: AppBar(
          title: Text(appState.current?.name ?? widget.title),
          actions: [
            if (context.watch<AppState>().edit)
              IconButton(
                icon: Icon(Icons.save),
                onPressed: appState.toggleEdit,
              )
            else
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: appState.toggleEdit,
              )
          ],
        ),
        body: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NoteList(_noteStore.notes, _showNote),
              NoteContent(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNote,
          tooltip: 'Add note',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _addNote() {
    print('Add Note');
  }

  void _showNote(Note selected) {
    print('SHOW: ${selected.toString().substring(0, 30)}');
    setState(() {
      appState.current = selected;
    });
  }
}
