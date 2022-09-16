import 'package:cached_network_image/cached_network_image.dart';
import 'package:cite_finder_admin/app/modules/ImageViewWidget/controllers/image_view_widget_controller.dart';
import 'package:cite_finder_admin/app/modules/ImageViewWidget/views/image_view_widget_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    Key? key,
    this.imageUrl =
        "https://images.unsplash.com/photo-1596233584351-73de5b4026d4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
    this.index,
    this.width,
    this.height,
    this.imageList,
  }) : super(key: key);

  final String imageUrl;
  final dynamic index;
  final double? width;
  final double? height;
  final List<String>? imageList;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () {
          Get.put(ImageViewWidgetController());
          Get.dialog(
            ImageViewWidgetView(
                imageUrl: imageUrl,
                heroTag: "Gallery_image_$index",
                galleryItems: imageList,
                galleryMode: imageList != null),
          );
        },
        child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Hero(
              tag: "Gallery_image_$index",
              child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: width,
                  height: height,
                  errorWidget: (ctx, o, s) =>
                      Center(child: Icon(Icons.broken_image, size: 30))),
            )));
  }
}
