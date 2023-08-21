import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/CircularButton.dart';
import '../../controllers/image_viewer_controller.dart';
import '../chats/controllers/chats_details_controller.dart';

class ImageViewWidget extends GetView<ImageViewerController> {
  const ImageViewWidget(
      {key,
      required this.imageUrl,
      this.isNetworkImage = true,
      required this.heroTag,
      this.imageType = "network",
      this.galleryMode = false,
      this.showInput = false,
      this.caption,
      this.onSend,
      this.bytes,
      this.galleryItems})
      : super(key: key);
  final String imageUrl;
  final bool isNetworkImage;
  final String heroTag;
  final String imageType;
  final bool galleryMode;
  final List<String>? galleryItems;

  final bool showInput;
  final String? caption;
  final Uint8List? bytes;

  final void Function(String)? onSend;

  @override
  Widget build(BuildContext context) {
    controller.pageParams = {
      'imageUrl': imageUrl,
      'galleryItems': galleryItems,
      'galleryMode': galleryMode
    };
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Get.focusScope?.unfocus();
          },
          child: Container(
            color: Colors.black,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                CarouselSlider.builder(
                    carouselController: controller.carouselController,
                    itemCount: galleryMode && galleryItems != null
                        ? galleryItems!.length
                        : 1,
                    itemBuilder: (context, index, rindex) {
                      final items = !galleryMode ? [imageUrl] : galleryItems!;
                      return InteractiveViewer(
                          child: imageType == 'network'
                              ? Hero(
                                  tag: heroTag,
                                  child: CachedNetworkImage(
                                      imageUrl: items[index],
                                      errorWidget: (ctx, o, s) =>
                                          Text("unableToLoadImage".tr),
                                      fit: BoxFit.contain,
                                      filterQuality: FilterQuality.high,
                                      progressIndicatorBuilder:
                                          (ctx, url, progress) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                              value: progress.totalSize != null
                                                  ? progress.downloaded /
                                                      progress.totalSize!
                                                  : null),
                                        );
                                      }))
                              : imageType == "asset"
                                  ? Hero(
                                      tag: heroTag,
                                      child: Image.asset(
                                        imageUrl,
                                        errorBuilder: (ctx, o, s) =>
                                            Text("unableToLoadImage".tr),
                                        filterQuality: FilterQuality.high,
                                        fit: BoxFit.contain,
                                      ))
                                  : imageType == 'memory' && bytes != null
                                      ? Hero(
                                          tag: heroTag,
                                          child: Image.memory(
                                            bytes!,
                                            errorBuilder: (ctx, o, s) {
                                              return Text(
                                                  "unableToLoadImage".tr);
                                            },
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.contain,
                                          ))
                                      : Hero(
                                          tag: heroTag,
                                          child: Image.file(
                                            File(imageUrl),
                                            errorBuilder: (ctx, o, s) {
                                              return Text(
                                                  "unableToLoadImage".tr);
                                            },
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.contain,
                                          )));
                    },
                    options: CarouselOptions(
                        aspectRatio: 1,
                        height: Get.height,
                        padEnds: false,
                        viewportFraction: 1,
                        enableInfiniteScroll: false)),
                Positioned(
                    top: 10,
                    left: 15,
                    child: InkWell(
                        onTap: () {
                          Get.back();
                          Get.delete<ImageViewerController>();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[500]!,
                                    blurRadius: 4,
                                    spreadRadius: 3)
                              ]),
                          child: Icon(Icons.arrow_back,
                              color: Get.theme.primaryColor, size: 30),
                        ))),
                if (galleryMode)
                  Positioned(
                      left: 20,
                      top: Get.height * 0.42,
                      child: CircularButton(
                          onTap: () {
                            controller.carouselController.previousPage();
                          },
                          color: Get.theme.colorScheme.tertiary,
                          child: const Icon(Icons.navigate_before))),
                if (galleryMode)
                  Positioned(
                      right: 20,
                      top: Get.height * 0.42,
                      child: CircularButton(
                          onTap: () {
                            controller.carouselController.nextPage();
                          },
                          color: Get.theme.colorScheme.tertiary,
                          child: const Icon(Icons.navigate_next))),

                //input for chat messages

                if (showInput && caption == null)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controller.inputController,
                        decoration: InputDecoration(
                            hintText: "enterMessage".tr,
                            hintStyle: Get.textTheme.bodyMedium!
                                .copyWith(color: Colors.grey[400]),
                            suffixIcon: InkWell(
                                onTap: () {
                                  Get.focusScope?.unfocus();
                                  if (onSend != null) {
                                    ChatDetailsController.to.isSending.value =
                                        true;
                                    onSend!(controller.inputController.text);

                                    controller.inputController.clear();
                                    Get.back();
                                  }
                                },
                                child: Icon(Icons.send_outlined,
                                    color: Get.theme.colorScheme.primary))),
                      ),
                    ),
                  ),

                if (!showInput && caption != null)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      child: Text(caption ?? '',
                          style: const TextStyle(color: Colors.white)),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
