import 'package:flutter/material.dart';
import 'package:mknotes/bl/note_store.dart';
import 'package:mknotes/ui/split.dart';

import 'list_widget.dart';
import 'note_widget.dart';
import 'search_widget.dart';

class SplitScreen extends StatelessWidget {
  final NoteStore noteStore;
  final Function showNote;

  const SplitScreen({Key key, this.noteStore, this.showNote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Split(
      axis: Axis.horizontal,
      children: [
        Column(
          children: [
            SearchField(),
            Expanded(child: NoteList(noteStore.notes, showNote)),
          ],
        ),
        NoteContent(),
      ],
      initialFractions: [0.3, 0.7],
    );
  }
}
