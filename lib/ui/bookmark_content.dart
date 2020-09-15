import 'package:flutter/material.dart';

import '../bl/bookmark.dart';
import '../extensions.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TagList(
              tags: bookmark?.tags ?? [],
              editable: editable,
              //FIXME: handle editing of bookmarks in the future
              // onAddTag: (tag) => appState.updateCurrentAddTag(tag),
              // onDeleteTag: (tag) => appState.updateCurrentRemoveTag(tag),
            ),
            TextField(
                controller: TextEditingController()..text = bookmark?.url,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16, bottom: 8),
                  labelText: 'url',
                  labelStyle:
                      TextStyle(height: -1, fontWeight: FontWeight.bold),
                )),
            TextField(
              controller: TextEditingController()..text = bookmark?.content,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 24, bottom: 8),
                labelText: 'description',
                labelStyle: TextStyle(height: -1, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text("Date: ${bookmark.timestamp.auFormat}"),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
