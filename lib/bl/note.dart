import 'package:meta/meta.dart';

class Note {
  final String name;
  final String content;
  final List<String> tags;

  Note({
    @required this.name,
    @required this.content,
    this.tags = const <String>[],
  });

  Note copyWith({
    String name,
    String content,
    List<String> tags,
  }) {
    return Note(
      name: name ?? this.name,
      content: content ?? this.content,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() => 'Note(name: $name, content: $content, tags: $tags)';
}
