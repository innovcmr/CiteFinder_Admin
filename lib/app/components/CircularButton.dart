import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton(
      {Key? key,
      this.child,
      this.onTap,
      this.radius = 50,
      this.color,
      this.elevation = 0})
      : super(key: key);

  final void Function()? onTap;
  final Widget? child;
  final double radius;
  final Color? color;
  final int elevation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onTap,
      child: Container(
        width: radius,
        height: radius,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color ?? Colors.grey[200]!.withOpacity(0.5),
            shape: BoxShape.circle,
            boxShadow: kElevationToShadow[elevation]),
        child: child,
      ),
    );
  }
}
