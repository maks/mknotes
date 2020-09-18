import 'dart:math' as m;

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

extension DateTimeExtension on DateTime {
  String get auFormat =>
      "${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-${year}";
}

extension StringExtension on String {
  String noMoreThan(int count) => substring(0, m.min(count, length));
}
