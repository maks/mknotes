import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maksnotes/bl/localdir_note_store.dart';

import 'bl/note.dart';
import 'bl/note_store.dart';

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
  final NoteStore _noteStore = LocalDirNoteStore(notesDir: Directory('./docs'));
  int _current;
  List<Note> itemList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StreamBuilder<List<Note>>(
                stream: _noteStore.notes,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  itemList = snapshot.data;
                  return Container(
                    width: 300,
                    color: Colors.lightBlueAccent,
                    child: ListView.builder(
                        itemCount: itemList.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return GestureDetector(
                            child: Text(itemList[index].name),
                            onTap: () => _showNote(index),
                          );
                        }),
                  );
                }),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(itemList?.elementAt(_current)?.content ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add note',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNote() {
    print('Add Note');
  }

  void _showNote(int index) {
    print('SHOW: $index');
    setState(() {
      _current = index;
    });
  }
}
