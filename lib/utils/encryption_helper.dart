import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Vernam cipher-based encryption/decryption.
/// The key is a random string of the same length as the plaintext.
/// We XOR the plaintext with the key, then store "key:ciphertext" in Base64.
class EncryptionHelper {
  /// Encrypts [plaintext] using Vernam cipher
  String encrypt(String plaintext) {
    if (plaintext.isEmpty) return '';

    // 1) Generate random key
    final randomKey = generateUniqueKey(plaintext.length);

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

//   String generateTrulyRandomKey(int length) {
//   const String baseChars = 
//     'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()-_=+[]{}|;:",.<>?/`~';
//   final Random secureRandom = Random.secure();

//   // Generate initial entropy
//   List<int> randomBytes = 
//     List<int>.generate(length * 2, (i) => secureRandom.nextInt(256));

//   // Convert entropy hash to bit representation
//   String entropyHash = sha256
//     .convert(randomBytes)
//     .bytes
//     .map((b) => b.toRadixString(2).padLeft(8, '0'))
//     .join();

//   // Bit-level randomization
//   List<String> result = [];
//   int bitIndex = 0;

//   while (result.length < length) {
//     // Rotate and mix bits
//     String rotatedBits = entropyHash.substring(bitIndex) + 
//                          entropyHash.substring(0, bitIndex);
    
//     // XOR with random bit stream
//     String mixedBits = rotatedBits.split('').map((bit) {
//       int randomBit = secureRandom.nextInt(2);
//       return (int.parse(bit) ^ randomBit).toString();
//     }).join();

//     // Select characters based on bit patterns
//     for (int i = 0; i + 6 < mixedBits.length && result.length < length; i += 6) {
//       // Take 6-bit chunks to map to base characters
//       String bitChunk = mixedBits.substring(i, i + 6);
//       int index = int.parse(bitChunk, radix: 2) % baseChars.length;
//       result.add(baseChars[index]);
//     }

//     // Regenerate entropy hash if we run out of bits
//     bitIndex = (bitIndex + 32) % entropyHash.length;
//     if (bitIndex == 0) {
//       randomBytes = List<int>.generate(length * 2, (i) => secureRandom.nextInt(256));
//       entropyHash = sha256
//         .convert(randomBytes)
//         .bytes
//         .map((b) => b.toRadixString(2).padLeft(8, '0'))
//         .join();
//     }
//   }
//   print("The key result"+result.join());
//   return result.join();
// }

String generateUniqueKey(int length) {
  const String baseChars = 
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()-_=+[]{}|;:",.<>?/`~';
  final Random secureRandom = Random.secure();

  // Generate initial entropy
  List<int> randomBytes = 
    List<int>.generate(length * 2, (i) => secureRandom.nextInt(256));

  // Hash-based unique key generation
  String entropyHash = sha256
    .convert(randomBytes)
    .bytes
    .map((b) => b.toRadixString(16).padLeft(2, '0'))
    .join();

  // Unique character tracking
  Set<String> usedChars = {};
  List<String> result = List.filled(length, '');

  for (int i = 0; i < length; i++) {
    // Use entropy to guide character selection
    final int entropyValue = 
      int.parse(entropyHash.substring(i % 32, (i % 32) + 2), radix: 16);
    
    // Find a unique character not used before
    for (int attempt = 0; attempt < baseChars.length; attempt++) {
      final int candidateIndex = 
        ((secureRandom.nextInt(256) ^ entropyValue + attempt) % baseChars.length);
      final String candidate = baseChars[candidateIndex];
      
      if (!usedChars.contains(candidate)) {
        result[i] = candidate;
        usedChars.add(candidate);
        break;
      }
    }

    // Regenerate entropy if unique character not found
    if (result[i].isEmpty) {
      randomBytes = 
        List<int>.generate(length * 2, (i) => secureRandom.nextInt(256));
      entropyHash = sha256
        .convert(randomBytes)
        .bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    }
  }
   print("The key result==> "+result.join());

  return result.join();
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