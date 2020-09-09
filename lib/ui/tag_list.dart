import 'package:flutter/material.dart';

class TagList extends StatelessWidget {
  final List<String> tags;
  final void Function(String) onDeleteTag;
  final bool editable;

  const TagList(
      {Key key, this.tags = const [], this.onDeleteTag, this.editable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tags
              ?.map<Widget>((e) => Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Chip(
                      label: Text(e),
                      onDeleted: editable ? (() => onDeleteTag(e)) : null,
                    ),
                  ))
              ?.toList() ??
          [],
    );
  }
}
