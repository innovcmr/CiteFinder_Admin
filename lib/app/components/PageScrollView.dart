import 'package:cite_finder_admin/app/components/CircularButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageScrollView extends StatelessWidget {
  const PageScrollView(
      {Key? key,
      this.scrollController,
      this.actions,
      this.appbarColor,
      this.title,
      this.onExit,
      this.body})
      : super(key: key);
  final ScrollController? scrollController;
  final List<Widget>? actions;
  final String? title;
  final Widget? body;
  final Color? appbarColor;
  final void Function()? onExit;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: appbarColor ?? Colors.white,

          leading: Get.routing.route != null && !Get.routing.route!.isFirst
              ? CircularButton(
                  color: Colors.grey[200],
                  child: const Icon(Icons.navigate_before),
                  onTap: () {
                    Get.back();
                    if (onExit != null) onExit!();
                  })
              : null,
          leadingWidth: 50,
          title: title != null
              ? Text(title!, style: Get.textTheme.titleLarge)
              : null,
          actions: actions,
          iconTheme: IconThemeData(color: Get.theme.primaryColor),
          // collapsedHeight: 80,
          floating: true,
          pinned: true,
        ),
        bodyBuilder()
      ],
    );
  }

  Widget bodyBuilder() => SliverToBoxAdapter(child: body);
}
