import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  // Static 32-byte key. In a real production app, use .env or a secure key management system.
  static final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
  // IV must be 16 bytes.
  static final _iv = encrypt.IV.fromUtf8('my16lengthsecret');
  
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  /// Encrypts plain text into a base64 encoded string
  static String encryptData(String plainText) {
    if (plainText.isEmpty) return plainText;
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypts a base64 encoded string back to plain text
  static String decryptData(String encryptedBase64) {
    if (encryptedBase64.isEmpty) return encryptedBase64;
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedBase64);
      return _encrypter.decrypt(encrypted, iv: _iv);
    } catch (e) {
      // If decryption fails (e.g. data is not encrypted or wrong key), return raw or a fallback
      return encryptedBase64; 
    }
  }
}
