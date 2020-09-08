import 'package:meta/meta.dart';
import 'dart:math' as math;

class Note {
  static const _UNTITLED = 'untitled';

  final String filename;
  final String title;
  final String content;
  final List<String> tags;

  String get name => title ?? filename.replaceAll(RegExp('_'), ' ');

  bool get isUntitled => title == _UNTITLED;

  Note({
    @required this.filename,
    @required this.content,
    this.title,
    this.tags = const <String>[],
  });

  factory Note.fromContent(String content) {
    final _title = _titleFromContent(content);
    final _filename = _title.replaceAll(RegExp(' '), '_');
    return Note(title: _title, filename: '$_filename.md', content: content);
  }

  factory Note.untitled({String content}) {
    return Note(content: content, filename: _UNTITLED);
  }

  Note copyWith({
    String name,
    String content,
    String title,
    List<String> tags,
  }) {
    return Note(
      filename: filename ?? this.filename,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() => 'Note(name: $name, content: $content, tags: $tags)';

  static String _titleFromContent(String content) {
    final maxTitleLength = 20;
    final title = content
        .substring(0, math.min(maxTitleLength, content.length))
        .replaceAll(RegExp(r'[.,!?\\-\\<>\[\]]'), '');
    final newLinePosition = title.indexOf('\n');
    return (newLinePosition > 0) ? title.substring(0, newLinePosition) : title;
  }
}
