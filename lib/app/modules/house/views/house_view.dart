// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cite_finder_admin/app/components/CircularButton.dart';
import 'package:cite_finder_admin/app/components/MapWidget.dart';
import 'package:cite_finder_admin/app/components/PageScrollView.dart';
import 'package:cite_finder_admin/app/components/crudComponentWidget.dart';
import 'package:cite_finder_admin/app/data/models/house_model.dart';
import 'package:cite_finder_admin/app/modules/house/views/home_room_view.dart';
import 'package:cite_finder_admin/app/modules/user/views/user_view.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
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
      body: CRUD(
        moduleName: "houses",
        searchController: controller.searchController,
        selectedTileIndexController: controller.selectedUserIndex,
        canEdit: false,
        createView: CreateEditView(
          mode: "create",
        ),
        // editView: CreateEditView(
        //   mode: "edit",
        // ),
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
  final controller = Get.put(HouseController.to);
  final String mode;
  House? moduleItem;
  @override
  Widget build(BuildContext context) {
    if (box.read(Config.keys.selectedHome) != null && mode != "create") {
      moduleItem = House.fromJson(box.read(Config.keys.selectedHome), "map");
    }
    log(moduleItem.toString());
    if (mode == "view") {
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
                      title: "${mode == "view" ? 'Approve/View' : 'Add'} Home",
                      onExit: () {
                        Get.delete<HouseController>();
                      },
                      body: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Form(
                          key: controller.getFormKey(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (mode != "view")
                                  Text(
                                      "Fill in the form below to add a new home"),
                                if (mode != "view") SizedBox(height: 30),
                                TextFormField(
                                  initialValue:
                                      mode == "view" ? moduleItem!.name : null,
                                  controller: mode != "view"
                                      ? controller.nameController
                                      : null,
                                  enabled: mode != "view",
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
                                  initialValue: mode == "view"
                                      ? moduleItem!.description
                                      : null,
                                  controller: mode != "view"
                                      ? controller.descriptionController
                                      : null,
                                  enabled: mode != "view",
                                  focusNode: controller.descriptionFocusNode,
                                  maxLines: 5,
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

                                //home type selector
                                DropdownButtonFormField<String>(
                                  value: mode == "view"
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
                                      enabled: mode != "view",
                                      prefixIcon: Icon(
                                          FontAwesomeIcons.houseChimneyWindow,
                                          size: 18)),
                                ),
                                SizedBox(height: 30),

                                //base price field
                                TextFormField(
                                  initialValue: mode == "view"
                                      ? moduleItem!.basePrice.toString()
                                      : null,
                                  controller: mode != "view"
                                      ? controller.basePriceController
                                      : null,
                                  enabled: mode != "view",
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
                                if (mode == "view") SizedBox(height: 30),
                                if (mode == "view")
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
                                                          //  mode == "view"
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
                                Text("Main Image (max: 5MB)",
                                    style: Get.textTheme.titleMedium),
                                SizedBox(height: 15),
                                if (mode != "view")
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
                                if (mode != "view") SizedBox(height: 15),
                                if (mode != "view")
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
                                // End of video section

                                SizedBox(height: 40),
                                //Other images selector
                                if (mode != "view")
                                  Text("Other Images (max 2MB each)",
                                      style: Get.textTheme.titleMedium),
                                if (mode != "view") SizedBox(height: 20),
                                if (mode != "view")
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
                                if (mode != "view") SizedBox(height: 20),

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
                                if (mode != "view") SizedBox(height: 40),
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
                                          initialValue: mode == "view"
                                              ? moduleItem!.location!.quarter
                                              : controller
                                                  .location.value.quarter,
                                          enabled: mode != "view",
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
                                        if (mode != "view")
                                          Text("Choose location on Map",
                                              style: Get.textTheme.titleMedium),
                                        if (mode != "view")
                                          SizedBox(height: 30),
                                        if (mode != "view")
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
                                if (mode != "view")
                                  Center(
                                    child: ElevatedButton(
                                        child: Text("Add Room Type"),
                                        onPressed: () async {
                                          // Get.to(() => AddHomeRoom(),
                                          //     transition: Transition.fadeIn);
                                        }),
                                  ),
                                if (mode != "view") SizedBox(height: 30),

                                //create button
                                Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (mode != "create" &&
                                            moduleItem?.isApproved != null &&
                                            moduleItem?.isApproved != true) {
                                          Get.defaultDialog(
                                            title: "Confirm Approval",
                                            middleText:
                                                "Are you really sure you want to approve this Home}  \n  This action cannot be undone",
                                            buttonColor:
                                                AppTheme.colors.mainRedColor,
                                            onCancel: () => Get.back(),
                                            onConfirm: () {
                                              controller
                                                  .approveHome(moduleItem!.id);
                                            },
                                          );

                                          controller
                                              .approveHome(moduleItem!.id);
                                        } else if (mode == "create") {
                                          controller.addHome();
                                        }
                                      },
                                      child: !controller.isLoading.value
                                          ? Text(mode == "view"
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