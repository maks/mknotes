import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bl/app_state.dart';
import '../bl/bookmark.dart';
import '../bl/note.dart';
import '../bl/reference_item.dart';
import '../extensions.dart';
import 'bookmark_content.dart';
import 'list_widget.dart';
import 'note_content.dart';
import 'search_field.dart';
import 'split.dart';

class SplitScreen extends StatelessWidget {
  final Stream<List<ReferenceItem>> itemsList;
  final Function(ReferenceItem selected) showItem;

  const SplitScreen({Key key, this.itemsList, this.showItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Split(
      axis: Axis.horizontal,
      minSizes: [100, 200],
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: [
                SearchField(),
                Expanded(child: ItemList(itemsList, showItem)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 2),
          child: ContentPane(),
        ),
      ],
      initialFractions: [0.3, 0.7],
    );
  }
}

class ContentPane extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appState = context.watch<AppState>();
    return _appState.current.isNull
        ? Container()
        : (_appState.current is Note
            ? NoteContent()
            : BookmarkContent(
                bookmark: _appState.current as Bookmark,
                editable: _appState.edit,
              ));
  }
}
