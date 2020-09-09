import 'package:flutter/material.dart';

class TagList extends StatelessWidget {
  final List<String> tags;

  const TagList({Key key, this.tags = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tags?.map<Widget>((e) => Chip(label: Text(e)))?.toList() ?? [],
    );
  }
}
