import 'package:cite_finder_admin/app/components/CircularButton%20copy.dart';
import 'package:cite_finder_admin/app/components/ImageWidget.dart';
import 'package:cite_finder_admin/app/data/models/house_model.dart';
import 'package:cite_finder_admin/app/modules/house/controllers/house_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeGallery extends StatelessWidget {
  const HomeGallery({Key? key, this.details}) : super(key: key);
  final House? details;
  static String name = "/home/gallery";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularButton(
                radius: 30,
                child: Icon(Icons.navigate_before, size: 30),
                onTap: () {
                  Get.back();
                }),
          ),
          title: Text(
            "${details?.name ?? 'home'} gallery",
          ),
          // iconTheme: IconThemeData(color: Get.theme.primaryColor),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (Get.width / 150).floor(),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: details?.images?.length ?? 0,
                itemBuilder: (ctx, index) {
                  return ImageWidget(
                      index: index,
                      imageUrl: details?.images?[index] ??
                          "https://images.unsplash.com/photo-1596233584351-73de5b4026d4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
                      imageList: details?.images);
                })));
  }
}
