import 'dart:math' as math;

import 'package:meta/meta.dart';
import 'package:mknotes/bl/item.dart';

class Note implements ReferenceItem {
  final String _title;
  final String _filename;
  @override
  final String content;
  @override
  final List<String> tags;

  @override
  bool get isUntitled => _title == UNTITLED || _filename == "$UNTITLED.md";

  bool get isEmpty => content?.trim()?.isEmpty ?? true;

  @override
  String get title => _title ?? _filename.replaceAll(RegExp('_'), ' ');

  String get filename =>
      _filename ?? "${_titleFromText(title).replaceAll(' ', '_')}.md";

  Note({
    String filename,
    @required this.content,
    @required String title,
    this.tags = const <String>[],
  })  : _title = _titleFromText(title),
        _filename = filename;

  factory Note.untitled(String content) {
    return Note(content: content, title: UNTITLED);
  }

  Note copyWith({
    String name,
    String content,
    String title,
    String filename,
    List<String> tags,
  }) {
    return Note(
      filename: filename ?? _filename,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() => 'Note(name: $title, content: $content, tags: $tags)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true;
    }
    return o is Note &&
        o._title == _title &&
        o._filename == _filename &&
        o.content == content;
  }

  @override
  int get hashCode {
    return _title.hashCode ^ _filename.hashCode ^ content.hashCode;
  }

  // enforce rules on what a title can be
  static String _titleFromText(String text) {
    if (text == null || text.isEmpty) {
      return null;
    }
    final maxTitleLength = 80;
    final title = text
        .substring(0, math.min(maxTitleLength, text.length))
        .replaceAll(RegExp(r'[.,!?\\-\\<>\[\]]'), '');
    final newLinePosition = title.indexOf('\n');
    return (newLinePosition > 0) ? title.substring(0, newLinePosition) : title;
  }
}
