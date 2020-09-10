import 'package:flutter/material.dart';

class TagList extends StatelessWidget {
  final List<String> tags;
  final void Function(String) onAddTag;
  final void Function(String) onDeleteTag;
  final bool editable;

  const TagList(
      {Key key,
      this.tags = const [],
      this.onDeleteTag,
      this.editable,
      this.onAddTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ...tags
              ?.map<Widget>((e) => Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Chip(
                      label: Text(e),
                      onDeleted: editable ? (() => onDeleteTag(e)) : null,
                    ),
                  ))
              ?.toList() ??
          [],
      Padding(
        padding: const EdgeInsets.only(left: 8),
        child: editable
            ? AddTagField(
                onAddTag: onAddTag,
              )
            : Container(),
      )
    ]);
  }
}

class AddTagField extends StatelessWidget {
  final void Function(String) onAddTag;

  const AddTagField({Key key, @required this.onAddTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: TextField(
        autofocus: true,
        maxLines: 1,
        decoration: InputDecoration(hintText: 'new tag'),
        onSubmitted: onAddTag,
      ),
    );
  }
}
