import 'dart:io';

import 'package:flutter/material.dart';

import 'note.dart';

Stream<Note> _readNotesFileList() {
  final notesDir = Directory('/home/maks/notes');

  final notesListStream = notesDir.list();

  return notesListStream.map((f) {
    print("note p: ${f.absolute.path}");
    return Note(name: f.absolute.path, content: '');
  });
}

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
  final itemList = <Note>[];
  final notesStream = _readNotesFileList();

  @override
  Widget build(BuildContext context) {
    itemList.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StreamBuilder<Note>(
                stream: notesStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  itemList.add(snapshot.data);
                  print("item: ${snapshot.data}");
                  return Container(
                    width: 300,
                    color: Colors.lightBlueAccent,
                    child: ListView.builder(
                        itemCount: itemList.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return Text(itemList[index].name);
                        }),
                  );
                }),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                  ),
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
}
