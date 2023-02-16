import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import '../tflite/custom_classifier.dart';

class AccountInfo {
  var username;
  var password;
  var newPassword;
  var email;
  var invitation_code;
  var status;
  var message;
  var error_code;
  var token;
  var device_name;
  var device_os;
  var device_token;
  var verify_valid_info;
  var expire_time;
  var expire_time_token;
  var type_login;
  var uid;
  User? user;
  String? title;
  File? image;
  Classifier? classifier;
  int? modelIndex;

  AccountInfo({
    this.username,
    this.token,
    this.expire_time_token,
    this.email,
    this.expire_time,
    this.type_login,
    this.status,
    this.message,
    this.error_code,
    this.invitation_code,
    this.newPassword,
    this.password,
    this.verify_valid_info,
    this.device_name,
    this.device_os,
    this.device_token,
    this.uid,
    this.user,
  });

  factory AccountInfo.fromMap(Map<String, dynamic> map) => AccountInfo(
        username: map["username"],
//        token: map["token"],
        expire_time_token: map["expire_time_token"],
        email: map["email"],
        type_login: map["type_login"],
        verify_valid_info: map["verify_valid_info"],
        device_name: map["device_name"],
        device_os: map["device_os"],
      );

  Map<String, dynamic> toMap() => {
        "username": username,
//        "token": token,
        "expire_time_token": expire_time_token,
        "email": email,
        "type_login": type_login,
      };
}
