import 'package:flutter/material.dart';

import 'package:mknotes/bl/bookmark.dart';

import 'tag_list.dart';

class BookmarkContent extends StatelessWidget {
  final Bookmark bookmark;
  final bool editable;

  const BookmarkContent({
    Key key,
    @required this.bookmark,
    @required this.editable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TagList(
            tags: bookmark?.tags ?? [],
            editable: editable,
            // onAddTag: (tag) => appState.updateCurrentAddTag(tag),
            // onDeleteTag: (tag) => appState.updateCurrentRemoveTag(tag),
          ),
          TextField(
              controller: TextEditingController()..text = bookmark?.url,
              decoration: InputDecoration(
                labelText: 'url',
                alignLabelWithHint: true,
              )),
          Divider(),
          TextField(
            controller: TextEditingController()..text = bookmark?.content,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'description',
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}
