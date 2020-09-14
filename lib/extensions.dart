import 'package:basics/basics.dart';

export 'package:basics/basics.dart';

extension ObjectExt on String {
  bool get isNotNullOrEmpty => isNotNull && isNotEmpty;
}
