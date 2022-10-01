import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
// Since our Note class is serializable, we need to add this line as well:
part 'note.g.dart';

const nuNoteFilename = "empty.md";
const nuNoteTitle = "new note";

@freezed
class Note with _$Note {
  const factory Note({
    required String title,
    required String filename,
    required String content,
    required String id,
  }) = _Note;

  factory Note.empty() => const Note(filename: nuNoteFilename, title: nuNoteTitle, content: "", id: "");

  factory Note.fromJson(Map<String, Object?> json) => _$NoteFromJson(json);

 
}
