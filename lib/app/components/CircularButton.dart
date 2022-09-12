import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CircularButton extends StatelessWidget {
  const CircularButton(
      {Key? key, this.child, this.onTap, this.radius = 50, this.color})
      : super(key: key);

  final void Function()? onTap;
  final Widget? child;
  final double radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onTap,
      child: Container(
        width: radius,
        height: radius,
        child: child,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[200]!.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
