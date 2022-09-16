// ignore_for_file: prefer_const_constructors

import 'package:cite_finder_admin/app/components/CircularButton%20copy.dart';
import 'package:cite_finder_admin/app/components/ImageWidget.dart';
import 'package:cite_finder_admin/app/modules/house/controllers/house_controller.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';

class HomeRoomView extends GetView<HouseController> {
  String mode;
  HomeRoomView({Key? key, this.index, this.mode = "create"}) : super(key: key);
  @override
  final controller = HouseController.to;
  final int? index;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.cancelRoom,
      child: FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.9,
        child: GestureDetector(
          onTap: (() {
            Get.focusScope?.unfocus();
          }),
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: controller.getRoomKey(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Ink(
                                decoration: ShapeDecoration(
                                  color: AppTheme.colors.greyInputColor,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  iconSize: 30,
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icon(
                                    Icons.chevron_left,
                                    color: AppTheme.colors.mainPurpleColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Room Information",
                                style: Get.textTheme.headline2!
                                    .copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),

                        //home type selector
                        Text("Room Type",
                            style: Get.textTheme.button!.copyWith(
                                color: AppTheme.colors.mainLightPurpleColor)),
                        SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: controller.roomType.value,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Please select a value";
                            }
                            return null;
                          },
                          items: Config.firebaseKeys.roomTypes
                              .map((roomType) => DropdownMenuItem(
                                  value: roomType, child: Text(roomType)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              controller.roomType.value = val;
                            }
                          },
                          hint: Text(
                            'Room Type',
                            style: Get.textTheme.bodyMedium!
                                .copyWith(color: Colors.grey[400]),
                          ),
                          style: Get.textTheme.bodyMedium!.copyWith(
                              fontSize: 14, color: Get.theme.primaryColor),
                          decoration: InputDecoration(
                              enabled: mode != "view",
                              prefixIcon: Icon(
                                  FontAwesomeIcons.houseChimneyWindow,
                                  size: 18)),
                        ),
                        SizedBox(height: 30),

                        //room description
                        TextFormField(
                          enabled: mode != "view",
                          controller: controller.roomDescriptionController,
                          maxLines: 5,
                          maxLength: 1000,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (val) {
                            if (val == null || val.isEmpty)
                              return "This field is required";
                            return null;
                          },
                          decoration: InputDecoration(
                              enabled: mode != "view",
                              prefixIcon: Icon(
                                FontAwesomeIcons.pencil,
                                size: 15,
                              ),
                              hintText: 'Enter room description',
                              labelText: "Description"),
                        ),
                        SizedBox(height: 20),

                        //room numbers
                        TextFormField(
                          enabled: mode != "view",
                          controller: controller.roomNumberController,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (val) {
                            if (val == null || val.isEmpty)
                              return "This field is required";

                            if (!GetUtils.isNumericOnly(val))
                              return "Field must contain a valid numeric amount";
                            return null;
                          },
                          decoration: InputDecoration(
                              enabled: mode != "view",
                              prefixIcon: Icon(
                                Icons.numbers_rounded,
                                size: 15,
                              ),
                              hintText: 'Enter number available',
                              labelText: "Number Available"),
                        ),
                        SizedBox(height: 20),

                        //room price
                        TextFormField(
                          enabled: mode != "view",
                          controller: controller.roomPriceController,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (val) {
                            if (val == null || val.isEmpty)
                              return "This field is required";

                            if (!GetUtils.isNum(val))
                              return "Field must contain a valid numeric amount";
                            return null;
                          },
                          decoration: InputDecoration(
                              enabled: mode != "view",
                              prefixIcon: Icon(
                                FontAwesomeIcons.moneyBill,
                                size: 15,
                              ),
                              suffix: Text("FCFA",
                                  style: TextStyle(color: Colors.grey[400])),
                              hintText: 'Enter room price',
                              labelText: "Room Price"),
                        ),
                        SizedBox(height: 20),

                        //room Images
                        Text(
                            "Room Type Images ${mode == "view" ? '(max 2MB each)' : ''}",
                            style: Get.textTheme.titleMedium),

                        SizedBox(height: 20),

                        Obx(() {
                          return ElevatedButton.icon(
                              onPressed: mode == "view"
                                  ? null
                                  : () async {
                                      // await controller.selectImage(true);
                                    },
                              icon: Icon(Icons.add,
                                  color: Get.theme.colorScheme.onPrimary,
                                  size: controller.isLoadingRoomImage.value
                                      ? 0
                                      : 24),
                              label: !controller.isLoadingRoomImage.value
                                  ? Text("Add Image")
                                  : SpinKitDualRing(
                                      color: Get.theme.colorScheme.onPrimary,
                                      size: 20,
                                      lineWidth: 4,
                                    ));
                        }),
                        SizedBox(height: 20),

                        Obx(() {
                          return controller.roomImages.length > 0
                              ? SizedBox(
                                  height: 3,
                                  // height: 150,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller.roomImages.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          // child: Stack(
                                          //   children: [
                                          //     ImageWidget(
                                          //       imageUrl:
                                          //           controller.roomImages[index],
                                          //       index: index,
                                          //     ),
                                          //     Positioned(
                                          //       right: 5,
                                          //       top: 5,
                                          //       child: CircularButton(
                                          //           color: Colors.red,
                                          //           radius: 30,
                                          //           onTap: () {
                                          //             controller.removeImage(
                                          //                 controller.roomImages[
                                          //                     index],
                                          //                 false,
                                          //                 true);
                                          //           },
                                          //           child: Icon(
                                          //               FontAwesomeIcons.xmark,
                                          //               color: Colors.white)),
                                          //     )
                                          //   ],
                                          // ),
                                        );
                                      }))
                              : SizedBox.shrink();
                        }),

                        SizedBox(height: 15),
                        if (mode == "view")
                          SizedBox(
                              height: 190,
                              width: double.infinity,
                              child: ListView.builder(
                                  itemCount: controller
                                          .currentHomeRooms2[index!]
                                          .images
                                          ?.length ??
                                      0,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, index2) {
                                    List<String> imageLk = controller
                                        .currentHomeRooms2[index!].images!;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 5),
                                      child: AspectRatio(
                                        aspectRatio: 4 / 3,
                                        child: ImageWidget(
                                          imageUrl: imageLk[index2],
                                          width: 100,
                                          height: 70,
                                          index: index2,
                                          imageList: imageLk,
                                        ),
                                      ),
                                    );
                                  })),

                        SizedBox(height: 30),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: ElevatedButton(
                                      child: Text("Cancel"),
                                      onPressed: mode == "view"
                                          ? null
                                          : () => controller.cancelRoom())),
                              SizedBox(width: 25),
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: ElevatedButton(
                                    child: Text("Confirm"),
                                    onPressed: mode == "view"
                                        ? null
                                        : () => controller.addRoom(),
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Colors.grey[200]!.withOpacity(.7),
                                        onPrimary:
                                            Get.theme.colorScheme.primary),
                                  )),
                            ]),
                        SizedBox(height: 40),
                      ]),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
