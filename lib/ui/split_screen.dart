import 'package:flutter/material.dart';
import 'package:mknotes/bl/item.dart';
import 'package:mknotes/bl/note_store.dart';
import 'package:mknotes/ui/split.dart';

import 'list_widget.dart';
import 'note_content.dart';
import 'search_field.dart';

class SplitScreen extends StatelessWidget {
  final NoteStore noteStore;
  final Function(ReferenceItem selected) showItem;

  const SplitScreen({Key key, this.noteStore, this.showItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Split(
      axis: Axis.horizontal,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Column(
            children: [
              SearchField(),
              Expanded(child: ItemList(noteStore.items, showItem)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 2),
          child: NoteContent(),
        ),
      ],
      initialFractions: [0.3, 0.7],
    );
  }
}
