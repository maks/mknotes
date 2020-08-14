import 'package:flutter/material.dart';

class NoteContent extends StatelessWidget {
  final String content;

  NoteContent(this.content);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(content ?? ''),
        ),
      ),
    );
  }
}
