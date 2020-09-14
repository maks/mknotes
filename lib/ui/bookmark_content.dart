import 'package:flutter/material.dart';
import 'package:mknotes/bl/bookmark.dart';

class BookmarkContent extends StatelessWidget {
  final Bookmark bookmark;

  const BookmarkContent({Key key, this.bookmark}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
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
