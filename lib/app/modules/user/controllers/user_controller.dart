import 'dart:developer';

import 'package:cite_finder_admin/app/controllers/crud_controller.dart';
import 'package:cite_finder_admin/app/data/models/user_model.dart';
import 'package:cite_finder_admin/app/data/providers/userProvider.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/formKeys.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:cite_finder_admin/app/utils/new_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

class UserController extends GetxController {
  final count = 0.obs;
  static UserController get to => Get.find();

  // List<User> get moduleItems => moduleItemList.value;
  final userProvider = UserProvider();
  final selectedUserIndex = Rxn<int>();

  final GlobalKey<FormState> _createUserFormKey = CreateUserFormKey();

  final searchController = TextEditingController();
  final autoValidate = false.obs;
  // final selectedUserRole = Config.firebaseKeys.userRole.first.obs;
  final selectedUserRole = "".obs;
  late TextEditingController userNameController;
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmationController;

  late FocusNode userRoleFocusNode;
  late FocusNode fullNameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode phoneNumberFocusNode;

  late FocusNode locationFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode passwordConfirmFocusNode;

  late String? initialFullName;
  late String? initialEmail;
  late String? initialLocation;
  late String? initialPhoneNumber;
  RxBool obscurePassword = true.obs;

  RxBool isDeleted = false.obs;

  RxString currentFilter = "all".obs;

  @override
  void onInit() {
    super.onInit();
    userProvider.onInit();
    //initialize text controllers
    userNameController = TextEditingController();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();

    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();

    //initialize focus nodes

    userRoleFocusNode = FocusNode();
    fullNameFocusNode = FocusNode();
    locationFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    phoneNumberFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    passwordConfirmFocusNode = FocusNode();
  }

  @override
  void onReady() {
    super.onReady();
  }

  getFormKey() {
    return _createUserFormKey;
  }

  void increment() => count.value++;

  void createNewUser() async {
    Get.focusScope?.unfocus();
    if (!_createUserFormKey.currentState!.validate()) {
      autoValidate(true);
      return;
    } else {
      Get.showLoader();
      // bool successful = false;
      try {
        var success = await userProvider.add(
            fullName: fullNameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text,
            role: selectedUserRole.value,
            phoneNumber: phoneNumberController.text.trim());
        if (success) {
          clear();
          Get.snackbar("Success",
              "User successfully Created. An Email verification has been sent.",
              duration: const Duration(seconds: 6));
          Get.closeLoader();
        }
      } catch (e) {
        Get.snackbar("Error in user Creation", e.toString());
        log("Successful User Creation");
        Get.closeLoader();
      } finally {
        Get.closeLoader();
      }
    }
  }

  Future<void> editUser(User? user) async {
    if (user == null) return;
  }

  void openFilter() {
    Get.dialog(
      AlertDialog(
        title: const Text("Filter Users"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("All"),
              selected: currentFilter.value == "all",
              selectedTileColor: Colors.amber[100],
              onTap: () {
                currentFilter.value = "all";
                CRUDController.to.updateList();
                Get.back();
              },
            ),
            ListTile(
              title: const Text("Landlords"),
              selected: currentFilter.value == "landlord",
              selectedTileColor: Colors.amber[100],
              onTap: () {
                currentFilter.value = "landlord";
                CRUDController.to.updateList();
                Get.back();
              },
            ),
            ListTile(
              title: const Text("Agents"),
              selected: currentFilter.value == "agent",
              selectedTileColor: Colors.amber[100],
              onTap: () {
                currentFilter.value = "agent";
                CRUDController.to.updateList();
                Get.back();
              },
            ),
            ListTile(
              title: const Text("Normal Users"),
              selected: currentFilter.value == "tenant",
              selectedTileColor: Colors.amber[100],
              onTap: () {
                currentFilter.value = "tenant";
                CRUDController.to.updateList();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void clear() {
    fullNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    autoValidate(false);
  }

  String? validatePasswords(String? value, [isConfirm = false]) {
    if (value == null || GetUtils.isLengthLessThan(value, 6)) {
      return "Passwords should contain atleast 6 characters";
    } else if (GetUtils.isCaseInsensitiveContains(
        value, fullNameController.text)) {
      return "password should not be the same as name";
    } else if (GetUtils.isCaseInsensitiveContains(
        value, emailController.text)) {
      return "password should not be the same as email";
    } else if (value !=
        (!isConfirm
            ? passwordConfirmationController.text
            : passwordController.text)) {
      return "The two passwords don't match";
    } else {
      return null;
    }
  }

  Future<List<User>> searchUsers(String key) async {
    final collection =
        FirebaseFirestore.instance.collection(Config.firebaseKeys.users);

    final snapshots =
        await (collection.where("fullName", isGreaterThanOrEqualTo: key).get());
    return snapshots.docs
        .map<User>((doc) => User.fromJson(doc, "document"))
        .toList();
    // return list
    //     .where((user) =>
    //         user.fullName!.toLowerCase().contains(key.toLowerCase()) ||
    //         user.email!.toLowerCase().contains(key.toLowerCase()) ||
    //         user.id!.toLowerCase().contains(key.toLowerCase()) ||
    //         user.phoneNumber!.toLowerCase().contains(key.toLowerCase()))
    //     .toList();
  }

  Future<void> updateUserRole(
      DocumentReference<Map<String, dynamic>> userRef, String role) async {
    runAsyncFunction(() async {
      try {
        await userRef.update({"role": role});
        Fluttertoast.showToast(msg: "User role updated.");
      } catch (e) {
        Fluttertoast.showToast(msg: "An unexpected error occured");
      }
    });
  }

  @override
  void onClose() {
    clear();
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();

    userRoleFocusNode.dispose();
    fullNameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordConfirmFocusNode.dispose();
    super.onClose();
  }
}
