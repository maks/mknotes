import 'package:basics/basics.dart';
import 'package:front_matter/front_matter.dart';

export 'package:basics/basics.dart';

extension ObjectExt on String {
  bool get isNotNullOrEmpty => isNotNull && isNotEmpty;
}

extension FrontMatterDocE on FrontMatterDocument {
  dynamic getData(String key) {
    return (data != null) ? data[key] : null;
  }
}
