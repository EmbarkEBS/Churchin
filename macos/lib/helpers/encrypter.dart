import 'package:encrypt/encrypt.dart';

//String plainText ='String to encrypt';
final key = Key.fromUtf8('3mtree8u51n33ss501ut10nm33n6v33r'); //combination of 16 character
final iv = IV.fromUtf8('m33n6v33r6561r6w');
String encryption(String texttoconvert)  {
  final encrypter = Encrypter(AES(key,mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(texttoconvert, iv: iv);
  return encrypted.base64;
}
String decryption(String textconvert)  {
  final encrypter = Encrypter(AES(key,mode: AESMode.cbc, padding: null));
  final decrypted = encrypter.decrypt(Encrypted.fromBase64(textconvert), iv: iv);
  return decrypted;
}
