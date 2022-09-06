import 'package:flutter/material.dart';

class LoginFormKey extends GlobalObjectKey<FormState> {
  LoginFormKey() : super("login" + DateTime.now().toIso8601String());
}

class CreateUserFormKey extends GlobalObjectKey<FormState> {
  CreateUserFormKey() : super("createUser" + DateTime.now().toIso8601String());
}

// class OTPFormKey extends GlobalObjectKey<FormState> {
//   OTPFormKey() : super(Config.otp + DateTime.now().toIso8601String());