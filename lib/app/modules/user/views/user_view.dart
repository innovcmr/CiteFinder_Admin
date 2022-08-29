import 'package:cite_finder_admin/app/components/crudComponentWidget.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:cite_finder_admin/app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserView extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Scaffold(
      backgroundColor: AppTheme.colors.mainGreyBg,
      body: CRUD(
        title: "Users",
        subTitle: "All Users",
        moduleItems: controller.moduleItems,
        searchController: controller.searchController,
        createEditView: CreateEditView(),
      ),
    );
  }
}

class CreateEditView extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Obx(
      (() =>
          //  Scaffold(
          // body:
          // SafeArea(
          //   child:
          FractionallySizedBox(
            alignment: Alignment.center,
            widthFactor: 0.9,
            heightFactor: 0.9,
            child: Card(
              child: Form(
                key: controller.createUserFormKey,
                autovalidateMode: controller.autoValidate.value
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: [
                          // fullName textfield
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: controller.fullNameController,
                              focusNode: controller.fullNameFocusNode,
                              validator: Validator.isRequired,
                              decoration: InputDecoration(
                                constraints: const BoxConstraints(
                                  maxWidth: 300,
                                  // maxHeight: 40,
                                ),
                                focusColor:
                                    AppTheme.colors.mainLightPurpleColor,
                                prefixIcon: const Icon(Icons.person),
                                labelText: "Full Name",
                              ),
                            ),
                          ),
                          // EMail TextField
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: controller.emailController,
                              focusNode: controller.emailFocusNode,
                              validator: Validator.email,
                              decoration: InputDecoration(
                                constraints: const BoxConstraints(
                                  maxWidth: 300,
                                  // maxHeight: 40,
                                ),
                                focusColor:
                                    AppTheme.colors.mainLightPurpleColor,
                                prefixIcon: const Icon(Icons.message),
                                labelText: "Email",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: controller.phoneNumberController,
                              focusNode: controller.phoneNumberFocusNode,
                              validator: Validator.phoneNumber,
                              decoration: InputDecoration(
                                constraints: const BoxConstraints(
                                  maxWidth: 300,
                                  // maxHeight: 40,
                                ),
                                focusColor:
                                    AppTheme.colors.mainLightPurpleColor,
                                prefixIcon: const Icon(Icons.message),
                                labelText: "Phone Number",
                              ),
                            ),
                          ),
                          // role form field
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: DropdownButtonFormField(
                                focusNode: controller.userRoleFocusNode,
                                value:
                                    controller.selectedUserRole.toLowerCase(),
                                decoration: const InputDecoration(
                                  constraints: BoxConstraints(
                                    maxWidth: 300,
                                    // maxHeight: 40,
                                  ),
                                  labelText: "User Role",
                                  hintText: "Select User Role",
                                ),
                                validator: Validator.isRequired,
                                onChanged: ((String? newValue) {
                                  controller.selectedUserRole(newValue);
                                }),
                                items: [
                                  for (var role in [
                                    "",
                                    ...Config.firebaseKeys.userRole
                                  ])
                                    DropdownMenuItem(
                                      value: role,
                                      child: Text(
                                        role.capitalizeFirst!,
                                      ),
                                    ),
                                ]),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: controller.passwordController,
                              focusNode: controller.passwordFocusNode,
                              obscureText: controller.obscurePassword.value,
                              validator: Validator.isRequired,
                              decoration: InputDecoration(
                                constraints: const BoxConstraints(
                                  maxWidth: 300,
                                  // maxHeight: 40,
                                ),
                                labelText: "Password",
                                helperText:
                                    "Password must be more than 6 letters and must be different from both email and username",
                                helperMaxLines: 3,
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    controller.obscurePassword.value =
                                        !controller.obscurePassword.value;
                                  },
                                  child: Icon(
                                      controller.obscurePassword.value
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 18),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller:
                                  controller.passwordConfirmationController,
                              focusNode: controller.passwordConfirmFocusNode,
                              obscureText: controller.obscurePassword.value,
                              validator: (value) =>
                                  controller.validatePasswords(value, true),
                              decoration: InputDecoration(
                                constraints: const BoxConstraints(
                                  maxWidth: 300,
                                  // maxHeight: 40,
                                ),
                                labelText: "Confirm Password",
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    controller.obscurePassword.value =
                                        !controller.obscurePassword.value;
                                  },
                                  child: Icon(
                                      controller.obscurePassword.value
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        // widthFactor: 0.5,
                        child: ElevatedButton(
                          onPressed: controller.createNewUser,
                          child: const Text('Create User'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
      // ),

      ),
    );
  }
}
