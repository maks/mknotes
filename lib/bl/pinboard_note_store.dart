import 'package:mknotes/bl/reference_item.dart';

import 'package:mknotes/bl/note.dart';

import 'package:mknotes/bl/filters.dart';
import 'package:pinboard/pinboard.dart' as pb;
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

import 'note_store.dart';

/// Local file based store
class PinboardNoteStore implements NoteStore {
  final _notesListStream = BehaviorSubject<Set<ReferenceItem>>();
  pb.Pinboard pbClient;

  PinboardNoteStore({@required String username, @required String token}) {
    pbClient = pb.Pinboard(username: username, token: token);

    _fetchNotes();
  }

  @override
  void addNote(Note note) {
    // TODO: implement addNote
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void filter(Filter filter) {
    // TODO: implement filter
  }

  @override
  Stream<List<ReferenceItem>> get items =>
      _notesListStream.map((s) => s.toList());

  @override
  void saveNote(Note note) {
    // TODO: implement saveNote
  }

  @override
  void updateNote(Note old, Note nue) {
    // TODO: implement updateNote
  }

  void _fetchNotes() async {
    final notes = await pbClient.notes.list();
    final pbNotes = await notes.notes;
    final _fullList = pbNotes
        .map((n) => Note(id: n.id, title: n.title, content: n.text))
        .toSet();
    _notesListStream.add(_fullList);
  }
}
