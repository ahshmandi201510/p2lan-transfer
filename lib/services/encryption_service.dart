import 'dart:typed_data';
import 'dart:math';
import 'package:pointycastle/export.dart';

/// Encryption service for P2P data transfer.
/// Provides AES-256-GCM authenticated encryption.
class EncryptionService {
  static const int _keySize = 32; // 256 bits
  static const int _ivSize = 16; // 128 bits (96 bits is also common for GCM)
  static const int _gcmTagSize = 16; // 128 bits for GCM authentication tag

  /// Generate a secure random key for encryption (AES-256).
  static Uint8List generateKey() {
    final random = Random.secure();
    final key = Uint8List(_keySize);
    for (int i = 0; i < _keySize; i++) {
      key[i] = random.nextInt(256);
    }
    return key;
  }

  /// Generate a secure random IV (Initialization Vector).
  static Uint8List generateIV() {
    final random = Random.secure();
    final iv = Uint8List(_ivSize);
    for (int i = 0; i < _ivSize; i++) {
      iv[i] = random.nextInt(256);
    }
    return iv;
  }

  /// Encrypts data using AES-256-GCM.
  /// Returns a map with 'ciphertext', 'iv', and 'tag'.
  static Map<String, Uint8List> encryptGCM(Uint8List data, Uint8List key) {
    final iv = generateIV();
    final cipher = GCMBlockCipher(AESEngine())
      ..init(true,
          AEADParameters(KeyParameter(key), _gcmTagSize * 8, iv, Uint8List(0)));

    final encrypted = cipher.process(data);

    // The authentication tag is the last _gcmTagSize bytes of the output
    final ciphertext = encrypted.sublist(0, encrypted.length - _gcmTagSize);
    final tag = encrypted.sublist(encrypted.length - _gcmTagSize);

    return {
      'ciphertext': ciphertext,
      'iv': iv,
      'tag': tag,
    };
  }

  /// Decrypts data using AES-256-GCM.
  /// Requires 'ciphertext', 'iv', and 'tag'. Returns null on failure.
  static Uint8List? decryptGCM(
      Map<String, Uint8List> encryptedData, Uint8List key) {
    try {
      final ciphertext = encryptedData['ciphertext'];
      final iv = encryptedData['iv'];
      final tag = encryptedData['tag'];

      if (ciphertext == null || iv == null || tag == null) {
        return null;
      }

      final cipher = GCMBlockCipher(AESEngine())
        ..init(
            false,
            AEADParameters(
                KeyParameter(key), _gcmTagSize * 8, iv, Uint8List(0)));

      // Combine ciphertext and tag for processing
      final fullEncrypted = Uint8List(ciphertext.length + tag.length)
        ..setAll(0, ciphertext)
        ..setAll(ciphertext.length, tag);

      return cipher.process(fullEncrypted);
    } catch (e) {
      // Decryption can fail if the key is wrong or data is tampered with,
      // which is an expected outcome for GCM.
      return null;
    }
  }
}
