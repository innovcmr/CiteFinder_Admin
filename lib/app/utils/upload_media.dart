// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';

const allowedFormats = {'image/png', 'image/jpeg', 'video/mp4', 'image/gif'};

class SelectedMedia {
  const SelectedMedia(this.storagePath, this.bytes);
  final String storagePath;
  final Uint8List bytes;
}

enum MediaSource {
  photoGallery,
  videoGallery,
  camera,
}

Future<SelectedMedia?> selectMediaWithSourceBottomSheet({
  BuildContext? context,
  double maxWidth = double.infinity,
  double maxHeight = 400.0,
  bool allowPhoto = true,
  bool allowVideo = false,
  String pickerFontFamily = 'Montserrat',
  String message = "Choose Source",
  Color textColor = const Color(0xFF111417),
  Color backgroundColor = const Color(0xFFF5F5F5),
}) async {
  // ignore: prefer_function_declarations_over_variables
  final createUploadMediaListTile =
      (String label, MediaSource mediaSource) => ListTile(
            title: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            tileColor: backgroundColor,
            dense: false,
            onTap: () => Get.back<MediaSource>(result: mediaSource),
          );
  final mediaSource = await Get.bottomSheet<MediaSource>(
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: ListTile(
                title: Text(message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500)),
                tileColor: backgroundColor,
                dense: false,
              ),
            ),
            const Divider(),
            if (allowPhoto && allowVideo) ...[
              createUploadMediaListTile(
                'Gallery (Photo)',
                MediaSource.photoGallery,
              ),
              const Divider(),
              createUploadMediaListTile(
                'Gallery (Video)',
                MediaSource.videoGallery,
              ),
            ] else if (allowPhoto)
              createUploadMediaListTile(
                'Gallery',
                MediaSource.photoGallery,
              )
            else
              createUploadMediaListTile(
                'Gallery',
                MediaSource.videoGallery,
              ),
            const Divider(),
            createUploadMediaListTile('Camera', MediaSource.camera),
            const Divider(),
            const SizedBox(height: 10),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      enableDrag: true);
  if (mediaSource == null) {
    return null;
  }
  return selectMedia(
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    isVideo: mediaSource == MediaSource.videoGallery ||
        (mediaSource == MediaSource.camera && allowVideo && !allowPhoto),
    mediaSource: mediaSource,
  );
}

Future<SelectedMedia?> selectMedia({
  required double maxWidth,
  required double maxHeight,
  bool isVideo = false,
  MediaSource mediaSource = MediaSource.camera,
}) async {
  final picker = ImagePicker();
  final source = mediaSource == MediaSource.camera
      ? ImageSource.camera
      : ImageSource.gallery;
  final pickedMediaFuture = isVideo
      ? picker.pickVideo(source: source)
      : picker.pickImage(
          maxWidth: maxWidth, maxHeight: maxHeight, source: source);
  final pickedMedia = await pickedMediaFuture;
  final mediaBytes = await pickedMedia?.readAsBytes();

  if (mediaBytes == null) {
    return null;
  }
  // TODO: add landlord user id here
  final currentUser = "1234";
  // Get.find<AuthController>().currentUser.value;
  if (currentUser != null && pickedMedia != null) {
    // change current user to currentUser!.id
    final path = storagePath(currentUser, pickedMedia.name, isVideo);
    return SelectedMedia(path, mediaBytes);
  }
  return null;
}

bool validateFileFormat(String filePath, BuildContext context) {
  if (allowedFormats.contains(mime(filePath))) {
    return true;
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text('Invalid file format: ${mime(filePath)}'),
    ));
  return false;
}

Future<SelectedMedia?> selectFile({
  List<String> allowedExtensions = const ['pdf'],
}) async {
  final pickedFiles = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: allowedExtensions,
  );
  if (pickedFiles != null || pickedFiles!.files.isEmpty) {
    return null;
  }

  final file = pickedFiles.files.first;
  if (file.bytes == null) {
    return null;
  }
  //  TODO: add landlord user id here

  final currentUser = "1234";
  //  Get.find<AuthController>().currentUser.value;

  if (currentUser != null && file.bytes != null) {
    //TODO: change current user to currentUser!.id
    final path = storagePath(currentUser, file.name, false);
    return SelectedMedia(path, file.bytes!);
  }
  return null;
}

String storagePath(String uid, String filePath, bool isVideo) {
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  // Workaround fixed by https://github.com/flutter/plugins/pull/3685
  // (not yet in stable).
  final ext = isVideo ? 'mp4' : filePath.split('.').last;
  return 'users/$uid/uploads/$timestamp.$ext';
}

void showUploadMessage(BuildContext context, String message,
    {bool showLoading = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (showLoading)
              Padding(
                padding: EdgeInsetsDirectional.only(end: 10.0),
                child: CircularProgressIndicator(),
              ),
            Text(message),
          ],
        ),
      ),
    );
}

Future<String> uploadToStorage(SelectedMedia media) async {
  final storage = FirebaseStorage.instance;
  final storageRef = storage.ref().child(media.storagePath);

  UploadTask uploadTask = storageRef.putData(media.bytes);

  final uploadTaskSnapshot = await uploadTask;

  final String downloadUrl = await uploadTaskSnapshot.ref.getDownloadURL();

  return downloadUrl;
}

Future<void> deleteFromStorage(String url) async {
  if (url.isEmpty) return;
  final storage = FirebaseStorage.instance;

  final storageRef = storage.refFromURL(url);

  await storageRef.delete();
}
