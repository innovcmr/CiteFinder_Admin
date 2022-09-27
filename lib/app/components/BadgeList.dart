import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BadgeList extends StatelessWidget {
  const BadgeList(
      {Key? key,
      this.onSelectBadge,
      required this.optionsList,
      required this.isOptionSelected,
      this.itemBuilder,
      this.height = 55,
      this.borderRadius = 30,
      this.padding,
      this.itemMargin,
      this.prefixIcon,
      this.suffixIcon,
      this.activeColor,
      this.inActiveColor,
      this.prefixSize = 19,
      this.suffixSize = 17,
      this.optionStyle,
      this.isObservable = true})
      : super(key: key);

  final void Function(String?)? onSelectBadge;
  final bool Function(String) isOptionSelected;
  final List<String> optionsList;
  final Widget Function(BuildContext, String, int)? itemBuilder;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? itemMargin;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double prefixSize;
  final double suffixSize;
  final Color? inActiveColor;
  final Color? activeColor;
  final bool isObservable;
  final TextStyle? optionStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        child: isObservable
            ? Obx(() {
                return BList(context);
              })
            : BList(context));
  }

  Widget BList(BuildContext context) {
    return ListView(
        scrollDirection: Axis.horizontal,
        children: optionsList
            .map((opt) => InkWell(
                  onTap: () {
                    if (onSelectBadge != null) onSelectBadge!(opt);
                  },
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: itemBuilder != null
                      ? itemBuilder!(context, opt, optionsList.indexOf(opt))
                      : Padding(
                          padding:
                              itemMargin ?? const EdgeInsets.only(right: 10),
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                prefixIcon != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4.0),
                                        child: Icon(
                                          prefixIcon,
                                          color: isOptionSelected(opt)
                                              ? Colors.white
                                              : Get.theme.primaryColor,
                                          size: prefixSize,
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                Text(
                                  opt,
                                  style: optionStyle?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isOptionSelected(opt)
                                              ? Colors.white
                                              : Get.theme.primaryColor) ??
                                      Get.textTheme.bodyMedium!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isOptionSelected(opt)
                                              ? Colors.white
                                              : Get.theme.primaryColor),
                                ),
                                suffixIcon != null
                                    ? Icon(
                                        suffixIcon,
                                        color: isOptionSelected(opt)
                                            ? Colors.white
                                            : Get.theme.primaryColor,
                                        size: suffixSize,
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                            alignment: Alignment.center,
                            padding: padding ??
                                EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 30),
                            margin: EdgeInsets.only(
                              top: 5,
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                                color: isOptionSelected(opt)
                                    ? activeColor ?? Get.theme.primaryColor
                                    : inActiveColor ?? Colors.grey[200],
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.07),
                                      offset: Offset(0, 4),
                                      spreadRadius: 1,
                                      blurRadius: 7)
                                ],
                                borderRadius:
                                    BorderRadius.circular(borderRadius)),
                          ),
                        ),
                ))
            .toList());
  }
}
