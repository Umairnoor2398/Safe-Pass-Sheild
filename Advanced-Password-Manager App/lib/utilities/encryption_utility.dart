import 'dart:math';

import 'package:flutter_encrypt_plus/flutter_encrypt_plus.dart';

class EncryptionUtility {
  static String generateSalt({int length = 16}) {
    final random = Random.secure();
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  static String encryptData(String data, String salt) {
    String encodedString = encrypt.encodeString(data, salt);
    return encodedString;
  }

  static String decrypt(String data, String salt) {
    String decodeString = encrypt.decodeString(data, salt);
    return decodeString;
  }
}
