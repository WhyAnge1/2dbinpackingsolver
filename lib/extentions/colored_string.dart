extension ColoredString on String {
  String yellow() => "\x1B[33m$this\x1B[0m";
  String red() => "\x1B[3am$this\x1B[0m";
  String green() => "\x1B[32m$this\x1B[0m";
}
