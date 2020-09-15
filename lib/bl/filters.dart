import 'package:mknotes/bl/item.dart';

/// A filter can be applied to a Note Store to apply a condition
/// to all notes to choose which notes are returned by the Store.
abstract class Filter {
  bool apply(ReferenceItem note);
}

class SearchFilter implements Filter {
  final String term;

  SearchFilter(this.term);

  @override
  bool apply(ReferenceItem item) {
    return item.title.contains(term) || (item.content?.contains(term) ?? false);
  }
}
