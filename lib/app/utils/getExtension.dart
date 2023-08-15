import 'package:cite_finder_admin/app/components/loaderWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:flutter/material.dart';

extension Utils on GetInterface {
  showLoader(
      {bool dismissible = false, bool canUserPop = false, bool dense = false}) {
    dialog(
        WillPopScope(
            onWillPop: () async {
              return canUserPop;
            },
            child: LoaderWidget(dense: dense)),
        barrierDismissible: dismissible);
  }

  closeLoader() {
    if (isDialogOpen ?? false) {
      Get.back();
    }
  }
}
