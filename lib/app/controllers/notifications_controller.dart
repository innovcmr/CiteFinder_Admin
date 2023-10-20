import 'dart:convert';
import 'dart:html';

import 'package:cite_finder_admin/app/utils/new_utils.dart';
import 'package:cite_finder_admin/app/utils/upload_media.dart';
import 'package:dio/dio.dart' as d;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import "package:http/http.dart" as http;

class NotificationsController extends GetxController {
  NotificationsController() : super();

  static NotificationsController get to => Get.find();

  static const String notificationUrl =
      "https://us-central1-citefinder.cloudfunctions.net/sendUsersNotifications";

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  Rx<SelectedMedia?> selectedImage = Rx(null);
  Rx<File?> webFile = Rx(null);

  Future<void> selectImage() async {
    selectedImage.value = await selectMediaWithSourceBottomSheet();

    if (selectedImage.value == null) {
      Fluttertoast.showToast(msg: "No image selected");
      return;
    }
    return;
  }

  Future<void> showNotificationForm(List<String> userIds) async {
    Get.dialog(AlertDialog(
        title: const Text("Send Notification"),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: bodyController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: "Message"),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Select an image(optional)",
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: InkWell(
              onTap: selectImage,
              child: const Icon(
                Icons.photo_camera,
                size: 60,
              ),
            ),
          ),
          Obx(() => selectedImage.value != null
              ? Text(selectedImage.value!.storagePath)
              : const SizedBox.shrink()),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                runAsyncFunction(() async {
                  await sendNotification(userIds);
                  Get.back();
                });
              },
              child: const Text(
                "Send",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ])));
  }

  Future<void> sendNotification(List<String> userIds) async {
    // Create Dio instance

    var request = http.MultipartRequest('POST', Uri.parse(notificationUrl));
    request.fields['title'] = titleController.text;
    request.fields['body'] = bodyController.text;
    request.fields['userIds'] = jsonEncode(userIds);

    if (selectedImage.value != null) {
      request.files.add(
        http.MultipartFile.fromBytes('image', selectedImage.value!.bytes,
            filename: 'image.${selectedImage.value!.extension}'),
      );
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Notification sent");
        return;
      }
      Fluttertoast.showToast(msg: "Failed to send notification");
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "An error occurred");
    }
  }
}
