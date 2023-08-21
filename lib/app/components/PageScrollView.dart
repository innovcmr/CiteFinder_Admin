import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'CircularButton.dart';

class PageScrollView extends StatelessWidget {
  const PageScrollView(
      {Key? key,
      this.scrollController,
      this.actions,
      this.appbarColor,
      this.title,
      this.onExit,
      this.showLeading = false,
      this.showScrollBar = true,
      this.overrideBackButton = false,
      this.appBarBottom,
      this.expandedHeight,
      this.collapsedHeight,
      this.body})
      : super(key: key);
  final ScrollController? scrollController;
  final List<Widget>? actions;
  final String? title;
  final Widget? body;
  final Color? appbarColor;
  final bool showLeading;
  final bool showScrollBar;
  final PreferredSizeWidget? appBarBottom;
  final double? expandedHeight;
  final double? collapsedHeight;

  /// Set this property to true if you want to override the default behavior of the back button using the [onExit] function
  final bool overrideBackButton;
  final void Function()? onExit;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: appbarColor ?? Get.theme.scaffoldBackgroundColor,
            scrolledUnderElevation: 1,

            leading:
                showLeading || (Get.rawRoute != null && !Get.rawRoute!.isFirst)
                    ? CircularButton(
                        color: Get.isDarkMode
                            ? Get.theme.colorScheme.surface
                            : Colors.grey[200],
                        child: Icon(Icons.navigate_before,
                            color: Get.isDarkMode
                                ? Get.theme.colorScheme.onSurface
                                : Get.theme.colorScheme.primary),
                        onTap: () {
                          if (!overrideBackButton) {
                            Get.back();
                          }
                          if (onExit != null) onExit!();
                        })
                    : null,
            leadingWidth: 50,
            expandedHeight: expandedHeight,
            collapsedHeight: collapsedHeight,
            title: title != null
                ? Text(title!, style: Get.textTheme.titleLarge)
                : null,
            actions: actions,
            iconTheme: IconThemeData(color: Get.theme.primaryColor),
            // collapsedHeight: 80,
            floating: true,

            pinned: true,
            bottom: appBarBottom,
          ),
          bodyBuilder()
        ],
      ),
    );
  }

  Widget bodyBuilder() => SliverToBoxAdapter(child: body);
}
