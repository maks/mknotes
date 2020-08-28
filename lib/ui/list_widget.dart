import 'package:flutter/material.dart';
import '../bl/note.dart';

class NoteList extends StatelessWidget {
  final notesStream;
  final void Function(Note selected) showNote;

  NoteList(this.notesStream, this.showNote);

  @override
  Widget build(BuildContext context) {
    List<Note> itemList;
    return StreamBuilder<List<Note>>(
        stream: notesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          itemList = snapshot.data;
          return Container(
            color: Theme.of(context).backgroundColor,
            child: ListView.separated(
                itemCount: itemList.length,
                separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                itemBuilder: (BuildContext ctx, int index) {
                  return ListTile(
                    title: Text(itemList[index].name),
                    dense: true,
                    onTap: () => showNote(itemList[index]),
                  );
                }),
          );
        });
  }
}
