import 'package:get/get.dart';

import '../controllers/image_view_widget_controller.dart';

class ImageViewWidgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageViewWidgetController>(
      () => ImageViewWidgetController(),
    );
  }
}
