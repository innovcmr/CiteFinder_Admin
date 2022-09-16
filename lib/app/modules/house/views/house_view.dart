// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cite_finder_admin/app/components/CircularButton.dart';
import 'package:cite_finder_admin/app/components/ImageWidget.dart';
import 'package:cite_finder_admin/app/components/MapWidget.dart';
import 'package:cite_finder_admin/app/components/PageScrollView.dart';
import 'package:cite_finder_admin/app/components/SmallImageWidget.dart';
import 'package:cite_finder_admin/app/components/crudComponentWidget.dart';
import 'package:cite_finder_admin/app/components/home_gallery.dart';
import 'package:cite_finder_admin/app/data/models/house_model.dart';
import 'package:cite_finder_admin/app/data/models/landlord_model.dart';
import 'package:cite_finder_admin/app/data/models/user_model.dart';
import 'package:cite_finder_admin/app/modules/home/views/home_view.dart';
import 'package:cite_finder_admin/app/modules/house/views/home_room_view.dart';
import 'package:cite_finder_admin/app/modules/user/views/user_view.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/getExtension.dart';
import 'package:cite_finder_admin/app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/themes/themes.dart';
import '../controllers/house_controller.dart';

class HouseView extends GetView<HouseController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HouseController());
    return Scaffold(
      backgroundColor: AppTheme.colors.mainGreyBg,
      appBar: HomeView().MainAppBar(),
      drawer: MainDrawer(),
      body: CRUD(
        moduleName: "houses",
        searchController: controller.searchController,
        selectedTileIndexController: controller.selectedUserIndex,
        canEdit: false,
        addBtnVisibility: false,
        createView: CreateEditView(
          mode: "create",
        ),
        // editView: CreateEditView(
        //   mode: "edit",
        // ),
        approveView: CreateEditView(
          mode: "approve",
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
  @override
  final String mode;

  @override
  HouseController controller = Get.put(HouseController());
  House? moduleItem;
  @override
  Widget build(BuildContext context) {
    controller = Get.put(HouseController.to);
    if (box.read(Config.keys.selectedHome) != null && mode != "create") {
      moduleItem = House.fromJson(box.read(Config.keys.selectedHome), "map");
    }
    // log(moduleItem!.toJson().toString());
    if (mode == "view" || mode == "approve") {
      if (moduleItem?.facilities != null) {
        for (var facility in moduleItem!.facilities!) {
          controller.setFacility(facility);
        }
        controller.location.update((location) {
          location!.city = moduleItem!.location!.city;
        });
      }
      controller.setRooms(moduleItem);
    }

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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: PageScrollView(
                      title:
                          "${mode == "view" ? 'View' : mode == "approve" ? 'Approve' : 'Add'} Home",
                      body: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Form(
                          key: controller.getFormKey(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (mode != "view" && mode != "approve")
                                  Text(
                                      "Fill in the form below to add a new home"),
                                if (mode != "view" && mode != "approve")
                                  SizedBox(height: 30),
                                TextFormField(
                                  initialValue:
                                      mode == "view" || mode == "approve"
                                          ? moduleItem!.name
                                          : null,
                                  controller:
                                      mode != "view" && mode != "approve"
                                          ? controller.nameController
                                          : null,
                                  enabled: mode != "view" && mode != "approve",
                                  focusNode: controller.nameFocusNode,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.other_houses_rounded,
                                        size: 15,
                                      ),
                                      hintText: 'Enter home name',
                                      labelText: "Name"),
                                ),
                                SizedBox(height: 15),
                                TextFormField(
                                  initialValue:
                                      mode == "view" || mode == "approve"
                                          ? moduleItem!.description
                                          : null,
                                  controller:
                                      mode != "view" && mode != "approve"
                                          ? controller.descriptionController
                                          : null,
                                  enabled: mode != "view" && mode != "approve",
                                  focusNode: controller.descriptionFocusNode,
                                  maxLines: 3,
                                  maxLength: 1000,
                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.pencil,
                                        size: 15,
                                      ),
                                      hintText: 'Enter home description',
                                      labelText: "Description"),
                                ),
                                SizedBox(height: 15),
                                if (mode == "view" || mode == "approve")
                                  // Gallery for view mode
                                  if (moduleItem!.images!.isNotEmpty)
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Gallery",
                                                  style: Get
                                                      .textTheme.titleLarge!
                                                      .copyWith(fontSize: 20)),
                                              TextButton(
                                                  onPressed: () {
                                                    Get.dialog(HomeGallery(
                                                        details: moduleItem));
                                                  },
                                                  child: Text("View All",
                                                      style: TextStyle(
                                                          color: Get
                                                              .theme
                                                              .colorScheme
                                                              .onSecondaryContainer)))
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        SizedBox(height: 15),
                                        SizedBox(
                                            height: 110,
                                            width: double.infinity,
                                            child: ListView.builder(
                                                itemCount: moduleItem
                                                        ?.images!.length ??
                                                    0,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (ctx, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20, right: 5),
                                                    child: AspectRatio(
                                                      aspectRatio: 4 / 3,
                                                      child: ImageWidget(
                                                        imageUrl: moduleItem
                                                                    ?.images![
                                                                index] ??
                                                            "https://images.unsplash.com/photo-1596233584351-73de5b4026d4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
                                                        width: 100,
                                                        height: 70,
                                                        index: index,
                                                        imageList:
                                                            moduleItem?.images,
                                                      ),
                                                    ),
                                                  );
                                                })),
                                        SizedBox(height: 30),
                                      ],
                                    ),
                                //home type selector
                                DropdownButtonFormField<String>(
                                  value: mode == "view" || mode == "approve"
                                      ? moduleItem!.type
                                      : controller.type.value,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Please select a value";
                                    }
                                    return null;
                                  },
                                  items: Config
                                      .firebaseKeys.availableAccomodations
                                      .map((city) => DropdownMenuItem(
                                          value: city, child: Text(city)))
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
                                  style: Get.textTheme.headline4!.copyWith(
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                      enabled:
                                          mode != "view" && mode != "approve",
                                      prefixIcon: Icon(
                                          FontAwesomeIcons.houseChimneyWindow,
                                          size: 18)),
                                ),
                                SizedBox(height: 30),

                                //base price field
                                TextFormField(
                                  initialValue:
                                      mode == "view" || mode == "approve"
                                          ? moduleItem!.basePrice.toString()
                                          : null,
                                  controller:
                                      mode != "view" && mode != "approve"
                                          ? controller.basePriceController
                                          : null,
                                  enabled: mode != "view" && mode != "approve",
                                  validator: (val) {
                                    if (val != null &&
                                        val.isNotEmpty &&
                                        !GetUtils.isNum(val)) {
                                      return "invalid value. Enter valid value or leave field empty";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.moneyBills,
                                        size: 15,
                                      ),
                                      hintText: 'Enter base price',
                                      labelText: "Base Price (Optional)"),
                                ),
                                if (mode == "view" || mode == "approve")
                                  SizedBox(height: 30),
                                if (mode == "view" || mode == "approve")
                                  customTextFieldFunction(
                                      moduleAttribute:
                                          moduleItem?.rating.toString() ?? '',
                                      labelText: "Rating",
                                      icondata: FontAwesomeIcons.star),
                                // Facilities selector
                                SizedBox(height: 30),
                                Text("Facilities",
                                    textAlign: TextAlign.left,
                                    style: Get.textTheme.headline2!.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black)),
                                SizedBox(height: 15),

                                Obx(() {
                                  return Wrap(
                                      spacing: 15,
                                      children: Config
                                          .firebaseKeys.availableFacilities
                                          .map((facility) => Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Checkbox(
                                                      value:
                                                          //  mode == "view" || mode == "approve"
                                                          //     ? controller.isFacilitySelected(
                                                          //         moduleItem!
                                                          //             .facilities!
                                                          //             .firstWhere((element) =>
                                                          //                 element ==
                                                          //                 facility))
                                                          //     :
                                                          controller
                                                              .isFacilitySelected(
                                                                  facility),
                                                      onChanged: (val) =>
                                                          controller
                                                              .setFacility(
                                                                  facility)),
                                                  Text(
                                                      facility.capitalize ??
                                                          facility,
                                                      style: Get
                                                          .textTheme.bodyMedium!
                                                          .copyWith(
                                                              color: AppTheme
                                                                  .colors
                                                                  .mainPurpleColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                ],
                                              ))
                                          .toList());
                                }),

                                SizedBox(height: 30),
                                //Main image selector
                                if (mode != "view" && mode != "approve")
                                  Text("Main Image (max: 5MB)",
                                      style: Get.textTheme.titleMedium),
                                if (mode != "view" && mode != "approve")
                                  SizedBox(height: 15),
                                if (mode != "view" && mode != "approve")
                                  Stack(
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            await controller.selectMainImage();
                                          },
                                          // onLongPress: () {
                                          //   if (controller.mainImage.value.isEmpty)
                                          //     return;
                                          //   Get.to(
                                          //       () => ImageViewWidget(
                                          //             imageUrl: controller
                                          //                 .mainImage.value,
                                          //             heroTag:
                                          //                 "new_home_main_image",
                                          //           ),
                                          //       transition:
                                          //           Transition.noTransition);
                                          // },
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Obx(() {
                                              return Container(
                                                  padding: EdgeInsets.all(10),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200]!
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: controller
                                                          .isLoadingMainImage
                                                          .value
                                                      ? CircularProgressIndicator()
                                                      : controller.mainImage
                                                              .value.isEmpty
                                                          ? Icon(
                                                              FontAwesomeIcons
                                                                  .image,
                                                              size: 60)
                                                          : Hero(
                                                              tag:
                                                                  "new_home_main_image",
                                                              child:
                                                                  CachedNetworkImage(
                                                                      imageUrl: controller
                                                                          .mainImage
                                                                          .value,
                                                                      errorWidget:
                                                                          (ctx,
                                                                              o,
                                                                              s) {
                                                                        print(
                                                                            s);
                                                                        return Text(
                                                                            "Unable to load image");
                                                                      },
                                                                      fit: BoxFit
                                                                          .contain,
                                                                      progressIndicatorBuilder: (ctx,
                                                                          url,
                                                                          progress) {
                                                                        return Center(
                                                                          child:
                                                                              CircularProgressIndicator(value: progress.totalSize != null ? progress.downloaded / progress.totalSize! : null),
                                                                        );
                                                                      }),
                                                            ));
                                            }),
                                          )),
                                      Obx(() {
                                        return controller.mainImage.isNotEmpty
                                            ? Positioned(
                                                right: 5,
                                                top: 5,
                                                child: CircularButton(
                                                    color: Colors.red,
                                                    radius: 30,
                                                    onTap: () {
                                                      controller.removeImage(
                                                          null, true);
                                                    },
                                                    child: Icon(
                                                        FontAwesomeIcons.xmark,
                                                        color: Colors.white)),
                                              )
                                            : SizedBox.shrink();
                                      })
                                    ],
                                  ),
                                // End of image section
                                //Short video selector

                                Text("Short Video (max: 5MB)",
                                    style: Get.textTheme.titleMedium),
                                if (mode != "view" && mode != "approve")
                                  SizedBox(height: 15),
                                if (mode != "view" && mode != "approve")
                                  Stack(
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            await controller.selectShortVideo();
                                          },
                                          // onLongPress: () {
                                          //   if (controller.videoController == null)
                                          //     return;

                                          //   Get.toNamed(VideoPlayerScreen.name,
                                          //       arguments: {
                                          //         Config.firebaseKeys.type:
                                          //             VideoType.Network,
                                          //         Config.firebaseKeys.source:
                                          //             controller.videoController!
                                          //                 .dataSource,
                                          //       });
                                          // },
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Obx(() {
                                              return Container(
                                                  padding: EdgeInsets.all(10),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200]!
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: controller
                                                          .isLoadingVideo.value
                                                      ? CircularProgressIndicator()
                                                      : controller
                                                                  .shortVideo
                                                                  .value
                                                                  .isEmpty ||
                                                              controller
                                                                      .videoController ==
                                                                  null
                                                          ? Icon(
                                                              FontAwesomeIcons
                                                                  .video,
                                                              size: 60)
                                                          : AspectRatio(
                                                              aspectRatio: controller
                                                                  .videoController!
                                                                  .value
                                                                  .aspectRatio,
                                                              child: VideoPlayer(
                                                                  controller
                                                                      .videoController!)));
                                            }),
                                          )),
                                      Obx(() {
                                        return controller.shortVideo.isNotEmpty
                                            ? Positioned(
                                                right: 5,
                                                top: 5,
                                                child: CircularButton(
                                                    color: Colors.red,
                                                    radius: 30,
                                                    onTap: () {
                                                      controller.removeVideo();
                                                    },
                                                    child: Icon(
                                                        FontAwesomeIcons.xmark,
                                                        color: Colors.white)),
                                              )
                                            : SizedBox.shrink();
                                      })
                                    ],
                                  ),
                                if (mode == "view" || mode == "approve")
                                  // Agent display
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10.0),
                                        child: Text("House Agent",
                                            style: Get.textTheme.titleLarge!
                                                .copyWith(fontSize: 20)),
                                      ),
                                      SizedBox(height: 15),
                                      StreamBuilder<User>(
                                          stream: controller.landlordProvider
                                              .currentLandLordStream(
                                                  moduleItem!.landlord!.id),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              // log(snapshot.data.toString());
                                            }
                                            // if (!snapshot.hasData)
                                            //   return Text("Landlord not found");

                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting)
                                              return SpinKitDualRing(
                                                color: Get.theme.primaryColor,
                                              );

                                            final landlord = snapshot.data!;
                                            log(landlord.toJson().toString());
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: InkWell(
                                                  hoverColor: AppTheme.colors
                                                      .mainLightPurpleColor,
                                                  // focusColor: AppTheme
                                                  //     .colors.mainPurpleColor,
                                                  highlightColor: AppTheme
                                                      .colors.mainGreyBg,
                                                  borderRadius:
                                                      BorderRadius.circular(25),

                                                  onTap: () async {
                                                    // Navigate to the selected landlord. Has Error
                                                    // for now
                                                    // await controller.box.write(
                                                    //     Config
                                                    //         .keys.selectedUser,
                                                    //     landlord.toJson());
                                                    // Get.dialog(CreateEditView(
                                                    //   mode: "view",
                                                    // ));
                                                  },
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      decoration: BoxDecoration(
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .tertiary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SmallImageWidget(
                                                                imageUrl: landlord
                                                                    .photoURL),
                                                            SizedBox(width: 20),
                                                            Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      landlord.fullName ??
                                                                          "Anonymous",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: Get
                                                                          .textTheme
                                                                          .bodyLarge!
                                                                          .copyWith(
                                                                              color: AppTheme.colors.mainPurpleColor,
                                                                              fontWeight: FontWeight.w900)),
                                                                  // SizedBox(
                                                                  //     height: 10),
                                                                  // Text(
                                                                  //     dateTimeFormat(
                                                                  //         "relative",
                                                                  //         controller
                                                                  //             .currentHome
                                                                  //             .value!
                                                                  //             .dateAdded),
                                                                  //     style: TextStyle(
                                                                  //         color: Colors
                                                                  //             .grey[500])),
                                                                  if (Get.width <=
                                                                      500)
                                                                    InkWell(
                                                                      child: Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Text(
                                                                              landlord.phoneNumber ?? "",
                                                                            ),
                                                                            if (landlord.phoneNumber != null &&
                                                                                landlord.phoneNumber!.isNotEmpty)
                                                                              FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green)
                                                                          ]),
                                                                    ),
                                                                  // if (landlord
                                                                  //         .id !=
                                                                  //     controller
                                                                  //         .authController
                                                                  //         .currentUser
                                                                  //         .value!
                                                                  //         .id)
                                                                  //   InkWell(
                                                                  //       onTap: () =>
                                                                  //           controller.initializeChat(
                                                                  //               landlord),
                                                                  //       child: Padding(
                                                                  //           padding: EdgeInsets.all(
                                                                  //               5),
                                                                  //           child: Text(
                                                                  //               "messageOwner".tr,
                                                                  //               style: TextStyle(decoration: TextDecoration.underline))))
                                                                  if (Get.width >
                                                                      500)
                                                                    InkWell(
                                                                      child: Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Text(
                                                                              landlord.phoneNumber ?? "",
                                                                            ),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            if (landlord.phoneNumber != null &&
                                                                                landlord.phoneNumber!.isNotEmpty)
                                                                              FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green)
                                                                          ]),
                                                                    ),
                                                                ]),
                                                          ])),
                                                ));
                                          }),
                                    ],
                                  ),
                                SizedBox(height: 40),
                                //Other images selector
                                if (mode != "view" && mode != "approve")
                                  Text("Other Images (max 2MB each)",
                                      style: Get.textTheme.titleMedium),
                                if (mode != "view" && mode != "approve")
                                  SizedBox(height: 20),
                                if (mode != "view" && mode != "approve")
                                  Obx(() {
                                    return ElevatedButton.icon(
                                        onPressed: () async {
                                          if (controller.isLoadingImage.value)
                                            return;
                                          await controller.selectImage();
                                        },
                                        icon: Icon(Icons.add,
                                            color:
                                                controller.isLoadingImage.value
                                                    ? Colors.transparent
                                                    : Get.theme.colorScheme
                                                        .onPrimary),
                                        label: !controller.isLoadingImage.value
                                            ? Text("Add Image")
                                            : SpinKitDualRing(
                                                color: Get.theme.colorScheme
                                                    .onPrimary,
                                                size: 20,
                                                lineWidth: 4,
                                              ));
                                  }),
                                if (mode != "view" && mode != "approve")
                                  SizedBox(height: 20),

                                Obx(() {
                                  return controller.images.length > 0
                                      ? SizedBox(
                                          height: 200,
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  controller.images.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15.0),
                                                  child: Stack(
                                                    children: [
                                                      // ImageWidget(
                                                      //   imageUrl: controller
                                                      //       .images[index],
                                                      //   index: index,
                                                      // ),
                                                      Positioned(
                                                        right: 5,
                                                        top: 5,
                                                        child: CircularButton(
                                                            color: Colors.red,
                                                            radius: 30,
                                                            onTap: () {
                                                              controller.removeImage(
                                                                  controller
                                                                          .images[
                                                                      index]);
                                                            },
                                                            child: Icon(
                                                                FontAwesomeIcons
                                                                    .xmark,
                                                                color: Colors
                                                                    .white)),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }))
                                      : SizedBox.shrink();
                                }),
                                if (mode != "view" && mode != "approve")
                                  SizedBox(height: 40),
                                //Location
                                Text("Location",
                                    style: Get.textTheme.titleMedium),

                                SizedBox(height: 20),
                                Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 20),
                                        //home type selector
                                        Obx(() {
                                          return DropdownButtonFormField<
                                              String>(
                                            value:
                                                controller.location.value.city,
                                            validator: (val) {
                                              if (val == null || val.isEmpty) {
                                                return "Please select a city";
                                              }
                                              return null;
                                            },
                                            items: Config
                                                .firebaseKeys.availableCities
                                                .map((city) => DropdownMenuItem(
                                                    value: city,
                                                    child: Text(city)))
                                                .toList(),
                                            onChanged: (val) {
                                              if (val != null) {
                                                controller.location
                                                    .update((location) {
                                                  location!.city = val;
                                                });
                                              }
                                            },
                                            hint: Text(
                                              'Select Town',
                                              style: Get.textTheme.bodyMedium!
                                                  .copyWith(
                                                      color: Colors.grey[400]),
                                            ),
                                            style: Get.textTheme.bodyMedium!
                                                .copyWith(
                                                    fontSize: 14,
                                                    color: AppTheme.colors
                                                        .mainPurpleColor),
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                    FontAwesomeIcons.building,
                                                    size: 18)),
                                          );
                                        }),
                                        SizedBox(height: 20),
                                        TextFormField(
                                          initialValue: mode == "view" ||
                                                  mode == "approve"
                                              ? moduleItem!.location!.quarter
                                              : controller
                                                  .location.value.quarter,
                                          enabled: mode != "view" &&
                                              mode != "approve",
                                          onChanged: (val) {
                                            controller.location
                                                .update((location) {
                                              location!.quarter = val;
                                            });
                                          },
                                          validator: (val) {
                                            if (val == null || val.isEmpty) {
                                              return "Please enter a quarter name";
                                            }

                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                FontAwesomeIcons.houseFlag,
                                                size: 15,
                                              ),
                                              hintText: 'Enter home quarter',
                                              labelText: "Quarter"),
                                        ),

                                        SizedBox(height: 30),
                                        if (mode != "view" && mode != "approve")
                                          Text("Choose location on Map",
                                              style: Get.textTheme.titleMedium),
                                        if (mode != "view" && mode != "approve")
                                          SizedBox(height: 30),
                                        if (mode != "view" && mode != "approve")
                                          Obx(() {
                                            return AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: MapWidget(
                                                  initialCameraPosition:
                                                      controller
                                                          .initialCameraPosition
                                                          .value,
                                                  onMapCreated:
                                                      controller.onMapCreated,
                                                  markers: controller
                                                      .markers.values
                                                      .toSet(),
                                                  onTap: (LatLng pos) async {
                                                    await Get.generalDialog<
                                                            LatLng>(
                                                        pageBuilder: (context,
                                                            value1, value2) {
                                                      return SafeArea(
                                                        child: Material(
                                                          child: Container(
                                                              color:
                                                                  Colors.white,
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                      "Select Location"),
                                                                  SizedBox(
                                                                      height:
                                                                          20),
                                                                  Obx(() {
                                                                    return Expanded(
                                                                        child:
                                                                            MapWidget(
                                                                      initialCameraPosition: controller
                                                                          .initialCameraPosition
                                                                          .value,
                                                                      markers: controller
                                                                          .markers
                                                                          .values
                                                                          .toSet(),
                                                                      onMapCreated:
                                                                          controller
                                                                              .onMapCreated,
                                                                      onTap:
                                                                          (pos) {
                                                                        controller
                                                                            .moveMarker(pos);
                                                                      },
                                                                    ));
                                                                  }),
                                                                  SizedBox(
                                                                      height:
                                                                          20),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                                    child: Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: ElevatedButton(
                                                                                child: Text("Ok"),
                                                                                onPressed: () {
                                                                                  Get.back(result: null);
                                                                                }),
                                                                          )
                                                                        ]),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          20),
                                                                ],
                                                              )),
                                                        ),
                                                      );
                                                    });

                                                    controller
                                                        .centralizeCamera();
                                                  }),
                                            );
                                          }),
                                      ],
                                    )),

                                SizedBox(height: 30),

                                Text("Home Rooms",
                                    style: Get.textTheme.titleMedium),

                                Obx(() {
                                  return controller.currentHomeRooms2.length > 0
                                      ? SizedBox(height: 20)
                                      : SizedBox.shrink();
                                }),

                                Obx(() {
                                  return controller.currentHomeRooms2.length > 0
                                      ? SizedBox(
                                          height: 140,
                                          width: double.infinity,
                                          child: ListView.builder(
                                              itemCount: controller
                                                  .currentHomeRooms2.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (ctx, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, right: 5),
                                                  child: InkWell(
                                                    onTap: () {
                                                      controller.initializeRoom(
                                                          controller
                                                                  .currentHomeRooms2[
                                                              index]);
                                                      Get.dialog(HomeRoomView(
                                                        mode: "view",
                                                        index: index,
                                                      ));
                                                      // Get.to(() => AddHomeRoom(),
                                                      //     transition:
                                                      //         Transition.fadeIn);
                                                    },
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          height: 100,
                                                          width: 100,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppTheme
                                                                .colors
                                                                .mainPurpleColor,
                                                            shape:
                                                                BoxShape.circle,
                                                            gradient:
                                                                RadialGradient(
                                                                    colors: [
                                                                  AppTheme
                                                                      .colors
                                                                      .mainPurpleColor
                                                                      .withOpacity(
                                                                          0.6),
                                                                  Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .secondary
                                                                      .withOpacity(
                                                                          0.6),
                                                                  Colors.white
                                                                      .withOpacity(
                                                                          0.6)
                                                                ],
                                                                    tileMode:
                                                                        TileMode
                                                                            .decal),
                                                          ),
                                                          child: Icon(
                                                            FontAwesomeIcons
                                                                .bed,
                                                            size: 35,
                                                            color: AppTheme
                                                                .colors
                                                                .mainPurpleColor,
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Text(
                                                            "${controller.currentHomeRooms2[index].type ?? ''} (${controller.currentHomeRooms2[index].numberAvailable ?? 0})",
                                                            style: Get.textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }))
                                      : SizedBox.shrink();
                                }),
                                SizedBox(height: 20),
                                if (mode != "view" && mode != "approve")
                                  Center(
                                    child: ElevatedButton(
                                        child: Text("Add Room Type"),
                                        onPressed: () async {
                                          // Get.to(() => AddHomeRoom(),
                                          //     transition: Transition.fadeIn);
                                        }),
                                  ),
                                if (mode != "view" && mode != "approve")
                                  SizedBox(height: 30),
                                //create button
                                // if (mode != "view")
                                Center(
                                  child: ElevatedButton(
                                      onPressed: mode != "view"
                                          ? () {
                                              if (mode == "approve" &&
                                                  moduleItem?.isApproved !=
                                                      null &&
                                                  moduleItem?.isApproved ==
                                                      false) {
                                                Get.defaultDialog(
                                                  title: "Confirm Approval",
                                                  middleText:
                                                      "Are you really sure you want to approve this Home}  \n  This action cannot be undone",
                                                  buttonColor:
                                                      Colors.blueAccent,
                                                  onCancel: () => Get.back(),
                                                  onConfirm: () {
                                                    controller.approveHome(
                                                        moduleItem!.id);
                                                  },
                                                );
                                              } else if (mode == "create") {
                                                controller.addHome();
                                              }
                                            }
                                          : null,
                                      child: !controller.isLoading.value
                                          ? Text(mode == "approve"
                                              ? 'Approve'
                                              : "Create")
                                          : SpinKitDualRing(
                                              color: Get
                                                  .theme.colorScheme.onPrimary,
                                              lineWidth: 4,
                                              size: 20)),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ),
                )),
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
        initialValue:
            mode != "view" && mode != "approve" ? null : moduleAttribute,
        enabled: mode != "view" && mode != "approve",
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
                            // if (mode == "view" || mode == "approve")
                            //   customTextFieldFunction(
                            //       moduleAttribute:
                            //           moduleItem!.location.toString(),
                            //       labelText: "Location",
                            //       icondata: Icons.location_on),
                            // if (mode == "view" || mode == "approve")
                            //   customTextFieldFunction(
                            //       moduleAttribute:
                            //           moduleItem!.dateAdded.toString(),
                            //       labelText: "Date added",
                            //       icondata: Icons.calendar_month_rounded),
                            // if (mode == "view" || mode == "approve")
                            //   customTextFieldFunction(
                            //       moduleAttribute:
                            //           moduleItem!.isVerified.toString(),
                            //       labelText: "Is Verified",
                            //       icondata: Icons.verified),
                            // if (mode == "view" || mode == "approve")
                            //   customTextFieldFunction(
                            //       moduleAttribute:
                            //           moduleItem!.isGoogleUser.toString(),
                            //       labelText: "Is Google user",
                            //       icondata: Icons.circle),
                            // if (mode == "view" || mode == "approve")
                            //   customTextFieldFunction(
                            //       moduleAttribute:
                            //           moduleItem!.isFacebookUser.toString(),
                            //       labelText: "Is Facebook user",
                            //       icondata: Icons.facebook),