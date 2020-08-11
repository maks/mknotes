import 'package:meta/meta.dart';

class Note {
  final String filename;
  final String title;
  final String content;
  final List<String> tags;

  get name => title ?? filename.replaceAll(RegExp('_'), ' ');

  Note({
    @required this.filename,
    @required this.content,
    this.title,
    this.tags = const <String>[],
  });

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
}
