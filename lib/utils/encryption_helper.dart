import 'dart:convert';
import 'dart:math';

/// Vernam cipher-based encryption/decryption.
/// The key is a random string of the same length as the plaintext.
/// We XOR the plaintext with the key, then store "key:ciphertext" in Base64.
class EncryptionHelper {
  /// Encrypts [plaintext] using Vernam cipher
  String encrypt(String plaintext) {
    if (plaintext.isEmpty) return '';

    // 1) Generate random key
    final randomKey = _generateRandomKey(plaintext.length);

    // 2) XOR plaintext with the key => ciphertext
    final ciphertext = _xor(plaintext, randomKey);

    // 3) Combine => key:ciphertext, then Base64 encode
    final combined = '$randomKey:$ciphertext';
    return base64Encode(utf8.encode(combined));
  }

  /// Decrypts [base64Ciphertext] 
  String decrypt(String base64Ciphertext) {
    if (base64Ciphertext.isEmpty) return '';

    final decoded = utf8.decode(base64Decode(base64Ciphertext));
    final parts = decoded.split(':');
    if (parts.length != 2) {
      throw 'Invalid ciphertext format. Expected "key:ciphertext"';
    }
    final key = parts[0];
    final ciphertext = parts[1];

    // XOR => original plaintext
    return _xor(ciphertext, key);
  }

  /// Generate random key of length [length], ASCII range 32..126
  String _generateRandomKey(int length) {
    final rnd = Random.secure();
    final sb = StringBuffer();
    for (int i = 0; i < length; i++) {
      final charCode = 32 + rnd.nextInt(95);
      sb.writeCharCode(charCode);
    }
    return sb.toString();
  }

  /// XOR two strings (same length)
  String _xor(String s1, String s2) {
    if (s1.length != s2.length) {
      throw 'Strings must have the same length for XOR operation';
    }
    final sb = StringBuffer();
    for (int i = 0; i < s1.length; i++) {
      sb.writeCharCode(s1.codeUnitAt(i) ^ s2.codeUnitAt(i));
    }
    return sb.toString();
  }
}
