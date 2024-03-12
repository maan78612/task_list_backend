import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Add hash functionality ot out String ID
extension HashStringExtention on String {

  /// return the SHA256 to this [String]
  String get hashValue {
    return sha256.convert(utf8.encode(this)).toString();
  }
}
