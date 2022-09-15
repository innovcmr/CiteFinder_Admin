import 'dart:developer';

import 'package:cite_finder_admin/app/components/controllers/crud_controller.dart';
import 'package:cite_finder_admin/app/data/models/kyc_model.dart';
import 'package:cite_finder_admin/app/data/models/user_model.dart';
import 'package:cite_finder_admin/app/data/providers/userProvider.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/formKeys.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class UserController extends GetxController {
  //TODO: Implement UserController

  final count = 0.obs;
  static UserController get to => Get.find();
  // final crudController = Get.find<CrudController>();

  // List<User> get moduleItems => moduleItemList.value;
  final userProvider = UserProvider();
  final selectedUserIndex = Rxn<int>();
  List<KYC> kycRequests = [];
  KYC? chosenKYC;


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
    // moduleItemList.bindStream(userProvider.moduleStream());
    // log("user count is ${moduleItems.length}");
    // log("user count is ${moduleItems.first.toString()}");
  }

  getFormKey() {
    return _createUserFormKey;
  }

  getKycRequests() async {
    kycRequests = await userProvider.getKycRequests();
    // currentKYCUser = await userProvider.getUser()
  }

  Future<bool> hasKYCApproved(User item) async {
    if (kycRequests.isEmpty) {
      await getKycRequests();
    }
    return item.isVerified != null &&
        item.isVerified == false &&
        kycRequests.any((element) => element.user == item.record);
  }

  approveKYC(moduleId) async {
    await userProvider.approveUserKYC(
        kycUid: chosenKYC!.id!, userUid: moduleId);
    await getKycRequests();
    Get.closeLoader();
  }

  void increment() => count.value++;

  void createNewUser() async {
    Get.focusScope?.unfocus();
    if (!_createUserFormKey.currentState!.validate()) {
      autoValidate(true);
      return;
    } else {
      Get.showLoader();
      bool successful = false;
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
