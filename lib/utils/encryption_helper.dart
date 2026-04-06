import 'dart:convert';

class EncryptionHelper {

  // 🔐 Encryption
  static String encrypt(String text) {
    try {
      return base64Encode(utf8.encode(text));
    } catch (e) {
      return text;
    }
  }

  // 🔓 Decryption
  static String decrypt(String text) {
    try {
      return utf8.decode(base64Decode(text));
    } catch (e) {
      return text;
    }
  }
}