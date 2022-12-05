extension BooleanExtension on num? {
  bool get toBool => this == 1;
}

extension IntegerExtension on bool? {
  int get toInteger {
    if (this == true) return 1;
    return 0;
  }
}
