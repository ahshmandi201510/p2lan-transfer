import 'package:isar/isar.dart';

/// Isar's fast hash function for converting a String to an Id.
Id fastHash(String value) {
  var hash = 0xcbf29ce484222325;

  for (var i = 0; i < value.length; i++) {
    final codeUnit = value.codeUnitAt(i);
    hash ^= codeUnit;
    hash *= 0x100000001b3;
  }

  return hash;
}
