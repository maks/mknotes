import 'package:front_matter/front_matter.dart';

extension FrontMatterDocE on FrontMatterDocument {
  dynamic getData(String key) {
    return (data != null) ? data[key] : null;
  }
}
