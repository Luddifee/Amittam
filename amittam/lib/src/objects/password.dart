import 'dart:convert';

import 'package:Amittam/src/libs/lib.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as crypt;

class Password {
  Password(
    String password, {
    @required String username,
    @required String platform,
    @required this.passwordType,
    String notes,
  }) {
    if (notes == null) notes = '';
    if (username == null) username = '';
    if (platform == null) platform = '';
    if (password == null) password = '';
    if (key == null)
      throw 'Masterpassword not defined! Password could not be initialized!';
    this.password = password;
    this.platform = platform;
    this.notes = notes;
    this.username = username;
  }

  static var key;

  static void updateKey(String s) {
    key = crypt.Key.fromUtf8(expandStringTo32Characters(s));
  }

  static set masterPassword(String s) =>
      Password.key = crypt.Key.fromUtf8(expandStringTo32Characters(s));

  PasswordType passwordType;

  String encryptedPlatform = '';
  String encryptedUsername = '';
  String encryptedNotes = '';
  String encryptedPassword = '';

  set platform(String s) => encryptedPlatform = encryptWithMasterPWToBase64(s);
  String get platform => decryptWithMasterPWFromBase64(encryptedPlatform);

  set username(String s) => encryptedUsername = encryptWithMasterPWToBase64(s);
  String get username => decryptWithMasterPWFromBase64(encryptedUsername);

  set notes(String s) => encryptedNotes = encryptWithMasterPWToBase64(s);
  String get notes => decryptWithMasterPWFromBase64(encryptedNotes);

  set password(String s) => encryptedPassword = encryptWithMasterPWToBase64(s);
  String get password => decryptWithMasterPWFromBase64(encryptedPassword);

  String encryptWithMasterPWToBase64(String decrypted) {
    if (decrypted.isEmpty) return '';
    try {
      return crypt.Encrypter(crypt.AES(key))
          .encrypt(decrypted, iv: crypt.IV.fromLength(16))
          .base64;
    } catch (e) {
      throw 'Incorrect data encryption behavior!';
    }
  }

  String decryptWithMasterPWFromBase64(String encrypted) {
    if (encrypted.isEmpty) return '';
    try {
      return crypt.Encrypter(crypt.AES(key)).decrypt(
          crypt.Encrypted.fromBase64(encrypted),
          iv: crypt.IV.fromLength(16));
    } catch (e) {
      throw 'Incorrect Masterpassword or incorrect data decryption behavior!';
    }
  }

  @override
  String toString() {
    return 'encryptedPlatform: $encryptedPlatform, '
        'encryptedUsername: $encryptedUsername, '
        'encryptedPassword: $encryptedPassword, '
        'encryptedNotes: $encryptedNotes'
        'passwordType: ${EnumToString.parse(passwordType)}';
  }

  Password.fromMap(Map<String, dynamic> json)
      : encryptedPlatform = json['encryptedPlatform'],
        encryptedUsername = json['encryptedUsername'],
        encryptedNotes = json['encryptedNotes'],
        encryptedPassword = json['encryptedPassword'],
        passwordType =
            EnumToString.fromString(PasswordType.values, json['passwordType']);

  factory Password.fromJson(String jsonString) {
    return Password.fromMap(json.decode(jsonString));
  }

  Map toMap() {
    return {
      'encryptedPlatform': this.encryptedPlatform,
      'encryptedUsername': this.encryptedUsername,
      'encryptedNotes': this.encryptedNotes,
      'encryptedPassword': this.encryptedPassword,
      'passwordType': EnumToString.parse(this.passwordType),
    };
  }

  String toJson() {
    return json.encode(toMap());
  }

  static String exportPasswordsToEncryptedString(List<Password> passwords) {
    List<String> tempStringList = [];
    print(passwords);
    for (Password password in passwords) {
      tempStringList.add(password.toJson());
    }
    String jsonDecrypted = jsonEncode(tempStringList);
    crypt.Encrypter crypter = crypt.Encrypter(crypt.AES(Password.key));
    return crypter.encrypt(jsonDecrypted, iv: crypt.IV.fromLength(16)).base64;
  }
}

String expandStringTo32Characters(String string) {
  String tempString = string;
  int i = 0;
  while (tempString.length < 32) {
    i++;
    tempString = '$tempString${string.substring(i)}';
    if (i >= string.length - 1) i = 0;
  }
  return tempString.replaceRange(31, tempString.length - 1, '');
}
