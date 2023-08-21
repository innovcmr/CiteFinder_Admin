import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../data/models/user.dart';
import '../data/models/user_model.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar(
      {Key? key,
      required this.currentUser,
      this.radius = 30,
      required this.heroTag,
      this.isLoading = false,
      this.onTap})
      : super(key: key);

  final AppUser currentUser;
  final Function()? onTap;
  final double radius;
  final String heroTag;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Hero(
        tag: heroTag,
        child: CircleAvatar(
            radius: radius,
            backgroundColor: Get.theme.colorScheme.secondary,
            backgroundImage: currentUser.photoURL != null
                ? CachedNetworkImageProvider(
                    currentUser.photoURL!,
                  )
                : null,
            child: isLoading
                ? SpinKitDualRing(color: Get.theme.primaryColor, size: 20)
                : currentUser.photoURL == null && currentUser.fullName != null
                    ? Text(
                        currentUser.fullName![0].toUpperCase(),
                        style: Get.textTheme.titleLarge!
                            .copyWith(color: Colors.white),
                      )
                    : const SizedBox.shrink()),
      ),
    );
  }
}
