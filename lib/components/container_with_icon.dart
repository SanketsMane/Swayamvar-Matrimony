import 'package:active_matrimonial_flutter_app/const/my_theme.dart';
import 'package:flutter/material.dart';

class ContainerWithIcon extends StatelessWidget {
  // variables
  final Gradient? gradient;
  final String? icon;
  final double? width;
  final double? height;
  final double? radius;

  final Color? color;
  final Function? onpressed;
  final double? opacity;
  final bool isChecked;

  const ContainerWithIcon({
    super.key,
    this.gradient,
    this.icon,
    this.width,
    this.height,
    this.radius,
    this.color,
    this.onpressed,
    this.opacity,
    this.isChecked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed as void Function()?,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius!)),
          color: color?.withOpacity(opacity!),
          gradient: color == null ? gradient : null,
        ),
        child: Center(
          child: ImageIcon(
            AssetImage("assets/icon/$icon"),
            size: 16.0,
            color: isChecked ? MyTheme.gull_grey : MyTheme.white,
          ),
        ),
        // child: FittedBox(
        //   fit: ,
        // ),
      ),
    );
  }
}
