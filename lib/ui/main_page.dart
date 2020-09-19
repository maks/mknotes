import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bl/app_state.dart';
import '../bl/reference_item.dart';

import '../logging.dart';
import 'split_screen.dart';

class MainPage extends StatefulWidget {
  final String title;

  MainPage({@required this.title});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: NoteTitle(
          title: (appState.current?.title ?? widget.title),
          editable: appState.edit,
          onChanged: (text) => appState.updateCurrentTitle(text),
        ),
        actions: [
          if (appState.edit)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: appState.toggleEdit,
            )
          else
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: appState.toggleEdit,
            ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, "/settings"),
          )
        ],
      ),
      body: Center(
        child: SplitScreen(
          itemsList: appState.allItems,
          showItem: (item) => _showNote(item, appState),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNote(appState),
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNote(AppState state) {
    state.newNote();
  }

  void _showNote(ReferenceItem selected, AppState state) {
    Log().debug('SHOW: ${selected.title}');
    setState(() {
      state.current = selected;
    });
  }
}

class NoteTitle extends StatelessWidget {
  final String title;
  final bool editable;
  final void Function(String) onChanged;

  const NoteTitle({Key key, this.editable, this.title, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return editable
        ? TextField(
            maxLines: 1,
            controller: TextEditingController()..text = title,
            onChanged: onChanged,
          )
        : Text(title);
  }
}
