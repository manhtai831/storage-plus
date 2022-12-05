import 'dart:convert';

import 'package:flutter/services.dart';

extension BooleanExtension on num? {
  bool get toBool => this == 1;
}

extension IntegerExtension on bool? {
  int get toInteger {
    if (this == true) return 1;
    return 0;
  }
}

extension Uint8ListExtension on Map<String, dynamic>? {
  Uint8List get toBytes => Uint8List.fromList(jsonEncode(this).codeUnits);
}

extension StringExtension on Uint8List? {
  String get string => String.fromCharCodes(this ?? []);
}
