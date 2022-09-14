import 'package:cached_network_image/cached_network_image.dart';
import 'package:cite_finder_admin/app/modules/ImageViewWidget/controllers/image_view_widget_controller.dart';
import 'package:cite_finder_admin/app/modules/ImageViewWidget/views/image_view_widget_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

class SmallImageWidget extends StatelessWidget {
  const SmallImageWidget(
      {Key? key,
      this.imageUrl,
      this.isLast = false,
      this.onLastNavigate,
      this.radius = 90,
      this.imageList,
      this.lastText})
      : super(key: key);

  final String? imageUrl;
  final bool isLast;
  final void Function()? onLastNavigate;
  final String? lastText;
  final double radius;
  final List<String>? imageList;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isLast) {
          Get.put(ImageViewWidgetController());
          Get.to(
            () => ImageViewWidgetView(
                imageUrl: imageUrl ?? "assets/images/Shapehome.png",
                imageType: imageUrl != null ? 'network' : 'asset',
                isNetworkImage: imageUrl != null,
                galleryItems: imageList,
                galleryMode: imageList != null,
                heroTag: "image_${DateTime.now().toIso8601String()}"),
          );
        } else {
          if (onLastNavigate != null) onLastNavigate!();
        }
      },
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
            width: radius,
            height: radius,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[300]!.withOpacity(0.7),
              border: Border.all(width: 4, color: Colors.white),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl ??
                      "https://images.unsplash.com/photo-1596233584351-73de5b4026d4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
                  fit: BoxFit.cover),
            ),
            child: lastText != null
                ? Text(lastText!,
                    style: Get.textTheme.titleLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w900))
                : null),
      ]),
    );
  }
}
// Stack(children: [
//             const CircularProgressIndicator(),
//             FadeInImage.memoryNetwork(
//                 placeholder: kTransparentImage,
//                 image: imageUrl ??
//                     "https://images.unsplash.com/photo-1596233584351-73de5b4026d4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
//           ]),
