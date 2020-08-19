import 'note.dart';

/// A filter can be applied to a Note Store to apply a condition
/// to all notes to choose which notes are returned by the Store.
abstract class Filter {
  bool apply(Note note);
}

class SearchFilter implements Filter {
  final String term;

  SearchFilter(this.term);

  @override
  bool apply(Note note) {
    // TODO: implement apply
    throw UnimplementedError();
  }
}
