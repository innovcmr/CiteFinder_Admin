// In this file, the default behavior for providers will be handled. All interceptors and initial firebase configurations will be made here
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';

abstract class BasePovider {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GetStorage box = GetStorage();
  final FirebaseAuth auth = FirebaseAuth.instance;

// late final FirebaseAuth mAuth;
  void onInit() {
    // Initialize Firebase Auth
  }
}
