// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'dart:html';

import 'dart:developer';

import 'package:cite_finder_admin/app/components/createEditView.dart';
import 'package:cite_finder_admin/app/data/models/user_model.dart';
import 'package:cite_finder_admin/app/modules/user/controllers/user_controller.dart';
import 'package:cite_finder_admin/app/utils/extensions.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CRUD extends GetView {
  CRUD(
      {Key? key,
      this.addBtnVisibility = true,
      this.onAdd,
      this.title,
      this.subTitle,
      this.showEditIcon = true,
      this.showDeleteIcon = true,
      required this.createEditView,
      required this.searchController,
      required this.moduleItems})
      : super(key: key);
  final String? title;
  final String? subTitle;
  final bool showEditIcon;
  final bool showDeleteIcon;
  List<dynamic> moduleItems;
  bool addBtnVisibility;
  final Function()? onAdd;
  final TextEditingController searchController;
  final userController = UserController();
  final GetView createEditView;
  // <Map<String, dynamic> createFormFields ={
  //   // "user" :{

  //   // }

  // }

//   @override
//   State<CRUD> createState() => _CRUDState();
// }

// class _CRUDState extends State<CRUD> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Title and add button section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? '',
                  style: Get.textTheme.headline2!
                      .copyWith(color: AppTheme.colors.mainPurpleColor),
                ),
                if (addBtnVisibility)
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return createEditView;
                          });
                    },
                    child: Text(
                      "+ADD",
                      style: Get.textTheme.headline4!
                          .copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)),
                        minimumSize: const Size(110, 40),
                        primary: AppTheme.colors.mainLightPurpleColor),
                  )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            // card section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        subTitle ?? '',
                        style: Get.textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                    ),
                    // SizedBox(height: 10),
                    // Searchbar section
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 30,
                            child: TextFormField(
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  contentPadding: EdgeInsets.zero,
                                  labelText: "Search Here",
                                  isDense: true,
                                  prefixIcon: Icon(Icons.search,
                                      color: AppTheme
                                          .colors.inputPlaceholderColor),
                                ),
                                controller: searchController),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_list),
                          splashRadius: 20,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert),
                          splashRadius: 20,
                        )
                      ],
                    ),

                    StreamBuilder<List<User>>(
                      stream: userController.userProvider.moduleStream(),
                      builder: (context, snapshot) {
                        final items = snapshot.data;
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData) {
                          log("items>>>>>>> ${items!.first.toString()}");
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                            "An error  occurred while retrieving ${title}",
                            textAlign: TextAlign.center,
                          ));
                        }
                        if (snapshot.data!.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text("No ${title} to show")),
                          );
                        }

                        return Column(
                          children: [
                            if (items!.isNotEmpty)
                              Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.greyInputColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      for (var key
                                          in items.first.toJson().keys.toList())
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Text(
                                              key,
                                              textAlign: TextAlign.center,
                                              style: Get.textTheme.headline4!
                                                  .copyWith(
                                                      color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 95)
                                    ],
                                  ),
                                ),
                              ),
                            for (var i in items)
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color:
                                                AppTheme.colors.mainGreyBg))),
                                child: ListTile(
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (var j in i.toJson().values)
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: ListTile(
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Text(j.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: Get
                                                      .textTheme.headline4!
                                                      .copyWith(
                                                          color: Colors.black)),
                                            ),
                                          ),
                                        ),
                                      IconButton(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3),
                                        constraints: const BoxConstraints(),
                                        onPressed: () {},
                                        splashRadius: 20,
                                        icon: Icon(Icons.remove_red_eye,
                                            size: 20,
                                            color: AppTheme
                                                .colors.mainPurpleColor),
                                      ),
                                      if (showEditIcon)
                                        IconButton(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          constraints: const BoxConstraints(),
                                          onPressed: () {},
                                          splashRadius: 20,
                                          icon: Icon(Icons.edit,
                                              size: 20,
                                              color: AppTheme
                                                  .colors.mainPurpleColor),
                                        ),
                                      if (showDeleteIcon)
                                        IconButton(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          constraints: const BoxConstraints(),
                                          onPressed: () {},
                                          splashRadius: 20,
                                          icon: Icon(Icons.delete,
                                              size: 20,
                                              color:
                                                  AppTheme.colors.mainRedColor),
                                        ),

                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.center,
                                      //   children: [

                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
