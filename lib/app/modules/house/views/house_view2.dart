import 'dart:developer';

import 'package:cite_finder_admin/app/components/crudComponentWidget.dart';
import 'package:cite_finder_admin/app/data/models/house_model.dart';
import 'package:cite_finder_admin/app/modules/user/views/user_view.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/themes/themes.dart';
import '../controllers/house_controller.dart';

class HouseView extends GetView<HouseController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HouseController());
    return Scaffold(
      backgroundColor: AppTheme.colors.mainGreyBg,
      body: CRUD(
        moduleName: "houses",
        searchController: controller.searchController,
        selectedTileIndexController: controller.selectedUserIndex,
        canEdit: false,
        onSearch: (key, houses) {
          return houses;
        },
        createView: CreateEditView(
          mode: "create",
        ),
        seeView: CreateEditView(
          mode: "view",
        ),
      ),
    );
  }
}

class CreateEditView extends GetView<HouseController> {
  CreateEditView({Key? key, this.mode = "create"}) : super(key: key);
  final box = GetStorage();
  final String mode;
  House? moduleItem;
  @override
  Widget build(BuildContext context) {
    if (box.read(Config.keys.selectedHome) != null && mode != "create") {
      moduleItem = House.fromJson(box.read(Config.keys.selectedUser), "map");
    }
    log(moduleItem.toString());
    final controller = Get.put(HouseController.to);
    return Obx(
      (() =>
          //  Scaffold(
          // body:
          // SafeArea(
          //   child:
          FractionallySizedBox(
            alignment: Alignment.center,
            widthFactor: 0.95,
            heightFactor: 0.95,
            child: GestureDetector(
              onTap: () {
                Get.focusScope?.unfocus();
              },
              child: Card(
                child: Form(
                  key: controller.getFormKey(),
                  autovalidateMode: controller.autoValidate.value
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.people_outline_rounded,
                                  color: AppTheme.colors.mainPurpleColor,
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  mode == "create"
                                      ? "New Homes"
                                      : mode == "edit"
                                          ? "Edit Home"
                                          : "View Home",
                                  style: Get.textTheme.headline2!.copyWith(
                                      color: AppTheme.colors.mainPurpleColor),
                                )
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(right: 20),
                              child: IconButton(
                                  splashRadius: 30,
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.close)),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          children: [
                            // fullName textfield
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue:
                                    mode != "view" ? null : moduleItem!.name,
                                enabled: mode != "view",
                                controller: mode == "view"
                                    ? null
                                    : controller.nameController,
                                focusNode: controller.nameFocusNode,
                                validator: Validator.isRequired,
                                decoration: InputDecoration(
                                  constraints: const BoxConstraints(
                                    maxWidth: 300,
                                    // maxHeight: 40,
                                  ),
                                  focusColor:
                                      AppTheme.colors.mainLightPurpleColor,
                                  prefixIcon:
                                      const Icon(Icons.other_houses_outlined),
                                  labelText: "Home Name",
                                ),
                              ),
                            ),

                            // EMail TextField
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: mode != "view"
                                    ? null
                                    : moduleItem!.description,
                                enabled: mode != "view",
                                controller: mode == "view"
                                    ? null
                                    : controller.descriptionController,
                                focusNode: controller.descriptionFocusNode,
                                validator: Validator.isRequired,
                                maxLines: 5,
                                maxLength: 1000,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                decoration: InputDecoration(
                                  constraints: const BoxConstraints(
                                    maxWidth: 300,
                                    // maxHeight: 40,
                                  ),
                                  focusColor:
                                      AppTheme.colors.mainLightPurpleColor,
                                  prefixIcon: const Icon(Icons.message),
                                  labelText: "Description",
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField<String>(
                                value: controller.type.value,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Please select a value";
                                  }
                                  return null;
                                },
                                items:
                                    Config.firebaseKeys.availableAccomodations
                                        .map(
                                          (accomodation) => DropdownMenuItem(
                                            value: accomodation,
                                            child: Text(accomodation),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    controller.type.value = val;
                                  }
                                },
                                hint: Text(
                                  'Home Type',
                                  style: Get.textTheme.bodyMedium!
                                      .copyWith(color: Colors.grey[400]),
                                ),
                                style: Get.textTheme.bodyMedium!.copyWith(
                                    fontSize: 14,
                                    color: Get.theme.primaryColor),
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.home_work_rounded,
                                        size: 18)),
                              ),
                            ),
                            // Phone number field
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: mode != "view"
                                    ? null
                                    : moduleItem!.basePrice.toString(),
                                enabled: mode != "view",
                                controller: mode == "view"
                                    ? null
                                    : controller.basePriceController,
                                focusNode: controller.basePriceFocusNode,
                                validator: Validator.isNumberOptional,
                                decoration: InputDecoration(
                                  constraints: const BoxConstraints(
                                    maxWidth: 300,
                                    // maxHeight: 40,
                                  ),
                                  focusColor:
                                      AppTheme.colors.mainLightPurpleColor,
                                  prefixIcon: const Icon(Icons.money),
                                  labelText: "Phone Number",
                                  hintText: "Enter Phone Number(Optional)",
                                ),
                              ),
                            ),

                            // facilities Section
                            //  Do not delete these three dots below
                            ...Config.firebaseKeys.availableFacilities
                                .map((facility) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                            value: controller
                                                .isFacilitySelected(facility),
                                            onChanged: (val) => controller
                                                .setFacility(facility)),
                                        Text(facility.capitalize ?? facility,
                                            style: Get.textTheme.bodyMedium!
                                                .copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold))
                                      ],
                                    ))
                                .toList(),
                            // role form field
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (mode != "view")
                          Center(
                            // widthFactor: 0.5,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Create Home'),
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
            ),
          )
      // ),

      ),
    );
  }

  Padding customTextFieldFunction({
    required String moduleAttribute,
    required String labelText,
    required IconData icondata,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: mode != "view" ? null : moduleAttribute,
        enabled: mode != "view",
        decoration: InputDecoration(
          constraints: const BoxConstraints(
            maxWidth: 300,
            // maxHeight: 40,
          ),
          focusColor: AppTheme.colors.mainLightPurpleColor,
          labelText: labelText,
          prefixIcon: Icon(icondata),
        ),
      ),
    );
  }
}

// // Extra attributes not in create or editform
                            // if (mode == "view")
                            //   customTextFieldFunction(
                            //       moduleAttribute:
                            //           moduleItem!.location.toString(),
                            //       labelText: "Location",
                            //       icondata: Icons.location_on),
                            // if (mode == "view")
                            //   customTextFieldFunction(
                            //       moduleAttribute:
                            //           moduleItem!.dateAdded.toString(),
                            //       labelText: "Date added",
                            //       icondata: Icons.calendar_month_rounded),
                            // if (mode == "view")
                            //   customTextFieldFunction(
                            //       moduleAttribute:
                            //           moduleItem!.isVerified.toString(),
                            //       labelText: "Is Verified",
                            //       icondata: Icons.verified),
                            // if (mode == "view")
                            //   customTextFieldFunction(
                            //       moduleAttribute:
                            //           moduleItem!.isGoogleUser.toString(),
                            //       labelText: "Is Google user",
                            //       icondata: Icons.circle),
                            // if (mode == "view")
                            //   customTextFieldFunction(
                            //       moduleAttribute:
                            //           moduleItem!.isFacebookUser.toString(),
                            //       labelText: "Is Facebook user",
                            //       icondata: Icons.facebook),