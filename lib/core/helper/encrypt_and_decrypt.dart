import 'package:encrypt/encrypt.dart';

abstract class EncryptAndDecrypt {
  String encryptData(String data);
  String decryptData(String data);
}

class EncryptAndDecryptPdf implements EncryptAndDecrypt {
  late Key key;
  late IV iv;

  EncryptAndDecryptPdf() {
    key = Key.fromSecureRandom(32);
    iv = IV.fromSecureRandom(16);
  }

  @override
  String decryptData(String data) {
    final encrypter = Encrypter(AES(key, padding: null));
    final decrypted = encrypter.decrypt(Encrypted.from64(data), iv: iv);
    return decrypted;
  }

  @override
  String encryptData(String data) {
    final encrypter = Encrypter(AES(key, padding: null));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }
}
