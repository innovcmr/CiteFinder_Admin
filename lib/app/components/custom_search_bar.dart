import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar(
      {Key? key,
      this.controller,
      this.onSubmitted,
      this.onChanged,
      this.hasFilterSet = false,
      this.onFilterClear,
      this.onFilter})
      : super(key: key);
  final TextEditingController? controller;
  final bool hasFilterSet;
  final void Function(String)? onSubmitted;
  final void Function()? onFilter;
  final void Function()? onFilterClear;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          textInputAction: TextInputAction.search,
          onSubmitted: onSubmitted,
          onChanged: onChanged,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search users by name, email or phone number'.tr,
            contentPadding:
                const EdgeInsets.only(left: 0, top: 15, bottom: 15, right: 5),
            prefixIcon: const Icon(FontAwesomeIcons.magnifyingGlass, size: 17),
            suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(
                height: 25,
                width: 1,
                color: const Color(0xFFA1A5C1),
              ),
              const SizedBox(width: 5),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                      onPressed: onFilter,
                      icon: Icon(Icons.filter_list,
                          size: 24, color: Get.theme.colorScheme.secondary)),
                  if (hasFilterSet)
                    Positioned(
                        top: 15,
                        right: 13,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                        ))
                ],
              ),
              const SizedBox(width: 5),
            ]),
          ),
        ),
        if (hasFilterSet)
          Align(
            alignment: Alignment.centerRight,
            child: MaterialButton(
              color: Get.theme.colorScheme.error.withOpacity(0.3),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              height: 30,
              minWidth: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: onFilterClear,
              child: Text("resetFilter".tr),
            ),
          )
      ],
    );
  }
}
