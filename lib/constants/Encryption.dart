import 'package:bcrypt/bcrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
final _iv = encrypt.IV.fromUtf8('abcdefghijklmnop');


//mã hoá email,phone
String encryptText(String text) {
  final encrypter = encrypt.Encrypter(encrypt.AES(_key));
  final encrypted = encrypter.encrypt(text, iv: _iv);
  return encrypted.base64;
}

// giải mã email và phone
String decryptText(String encryptedText) {
  final encrypter = encrypt.Encrypter(encrypt.AES(_key));
  final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
  return decrypted;
}


