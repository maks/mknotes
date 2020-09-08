import 'dart:math' as math;

import 'package:meta/meta.dart';

class Note {
  static const _UNTITLED = 'untitled';

  final String _title;

  final String filename;
  final String content;
  final List<String> tags;

  String get name => title ?? filename.replaceAll(RegExp('_'), ' ');

  bool get _isUntitled => _title == _UNTITLED;

  bool get isEmpty => content?.trim()?.isEmpty ?? true;

  String get title => _title;

  Note({
    @required this.filename,
    @required this.content,
    @required String title,
    this.tags = const <String>[],
  }) : _title = _titleFromText(title);

  factory Note.untitled(String content) {
    return Note(content: content, title: _UNTITLED, filename: "$_UNTITLED.md");
  }

  Note copyWith({
    String name,
    String content,
    String title,
    String filename,
    List<String> tags,
  }) {
    return Note(
      filename: filename ?? this.filename,
      title: _titleFromText(title) ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() => 'Note(name: $name, content: $content, tags: $tags)';

  // enforce rules on what a title can be
  static String _titleFromText(String text) {
    final maxTitleLength = 80;
    final title = text
        .substring(0, math.min(maxTitleLength, text.length))
        .replaceAll(RegExp(r'[.,!?\\-\\<>\[\]]'), '');
    final newLinePosition = title.indexOf('\n');
    return (newLinePosition > 0) ? title.substring(0, newLinePosition) : title;
  }
}
