// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'dart:html';

import 'package:cite_finder_admin/app/utils/extensions.dart';
import 'package:cite_finder_admin/app/utils/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CRUD extends StatefulWidget {
  CRUD({
    Key? key,
    this.addBtnVisibility = true,
    this.onAdd,
    this.title,
    this.subTitle,
    required this.searchController,
  }) : super(key: key);
  final String? title;
  final String? subTitle;
  bool addBtnVisibility;
  final Function()? onAdd;
  final TextEditingController searchController;
  List<Map<String, dynamic>> mockData = [
    {
      "id": "01",
      "name": "ck plaza",
      "description": "Very popular cite. Come one come all",
      "type": "hostel",
      "shortVideo": "public/ckplaza/vid.mp4",
      "rating": 4.4,
      "mainImage": "public/ckplaza/mainImg.jpg",
      "dateAdded": "30/12/2022",
      "basePrice": 230.5
    },
    {
      "id": "02",
      "name": "",
      "description": "",
      "type": "",
      "shortVideo": "",
      "rating": "",
      "mainImage": "",
      "dateAdded": "",
      "basePrice": ""
    },
    {
      "id": "03",
      "name": "",
      "description": "",
      "type": "",
      "shortVideo": "",
      "rating": "",
      "mainImage": "",
      "dateAdded": "",
      "basePrice": ""
    }
  ];

  @override
  State<CRUD> createState() => _CRUDState();
}

class _CRUDState extends State<CRUD> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                  widget.title ?? '',
                  style: Get.textTheme.headline2!
                      .copyWith(color: AppTheme.colors.mainPurpleColor),
                ),
                if (widget.addBtnVisibility)
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "+ADD",
                      style: Get.textTheme.headline4!
                          .copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)),
                        minimumSize: const Size(110, 30),
                        primary: AppTheme.colors.mainLightPurpleColor),
                  )
              ],
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
                        widget.subTitle ?? '',
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
                                controller: widget.searchController),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_list),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert),
                        )
                      ],
                    ),
                    Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        // TableRow(children: [
                        //   ...widget.mockData
                        //       .mapIndexed(
                        //         (item, index) => Column(
                        //           children: [Text(item.keys.toList()[index])],
                        //         ),
                        //       )
                        //       .toList()
                        // ])
                        TableRow(
                            decoration: BoxDecoration(
                                color: AppTheme.colors.greyInputColor,
                                borderRadius: BorderRadius.circular(5)),
                            children: [
                              for (var item in widget.mockData[0].keys.toList())
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      item,
                                      textAlign: TextAlign.center,
                                      style: Get.textTheme.headline4!
                                          .copyWith(color: Colors.black),
                                    ),
                                  ),
                                ),
                            ]),
                        for (var i in widget.mockData)
                          TableRow(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: AppTheme.colors.mainGreyBg))),
                              children: [
                                for (var j in widget
                                    .mockData[widget.mockData.indexOf(i)].values
                                    .toList())
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Text(
                                      j.toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))
                              ]),
                      ],
                    ),
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
