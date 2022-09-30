import 'package:flutter/material.dart';
import '../bl/note.dart';
import '../bl/reference_item.dart';

class ItemList extends StatelessWidget {
  final Stream<List<ReferenceItem>> itemsStream;
  final void Function(ReferenceItem selected) showNote;

  ItemList(this.itemsStream, this.showNote);

  @override
  Widget build(BuildContext context) {
    List<ReferenceItem> itemList;
    return StreamBuilder<List<ReferenceItem>>(
        stream: itemsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
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
                  final item = itemList[index];
                  return ListTile(
                    title: Text(item.title),
                    leading: (item is Note)
                        ? Icon(Icons.notes)
                        : Icon(Icons.bookmark),
                    dense: true,
                    onTap: () => showNote(itemList[index]),
                  );
                }),
          );
        });
  }
}
