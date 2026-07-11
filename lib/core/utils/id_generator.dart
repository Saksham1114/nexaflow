class IdGenerator {
  IdGenerator._();

  static String generate() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
