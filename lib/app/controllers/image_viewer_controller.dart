import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageViewerController extends GetxController {
  CarouselController carouselController = CarouselController();

  Map<String, dynamic> pageParams = {};
  List<String> imageList = [];

  TextEditingController inputController = TextEditingController();

  @override
  void onReady() {
    if (pageParams['galleryItems'] != null &&
        pageParams['galleryMode'] == true &&
        pageParams['imageUrl'] != null) {
      imageList = pageParams['galleryItems'] as List<String>;
      final imageUrl = pageParams['imageUrl'] as String;

      final int index = imageList.indexOf(imageUrl);

      if (index > -1) {
        carouselController.jumpToPage(index);
      }
    }

    super.onReady();
  }
}
