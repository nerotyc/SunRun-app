import 'package:flutter/material.dart';

import 'package:sonnen_rennt/constants/color.dart';

class DrawerTile extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Function? onTap;
  final bool isSelected;
  final Color iconColor;

  DrawerTile(
      {this.title,
      this.icon,
      this.onTap,
      this.isSelected = false,
      this.iconColor = SunRunColors.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
          margin: EdgeInsets.only(top: 6),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: isSelected
                        ? SunRunColors.black.withOpacity(0.07)
                        : Colors.transparent,
                    offset: Offset(0, 0.5),
                    spreadRadius: 3,
                    blurRadius: 10)
              ],
              color: isSelected ? SunRunColors.primary : SunRunColors.secondary,
              borderRadius: BorderRadius.all(Radius.circular(54))),
          child: Row(
            children: [
              Icon(icon,
                  size: 18,
                  color: isSelected
                      ? SunRunColors.primary
                      : SunRunColors.white.withOpacity(1.0)),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(title!,
                    style: TextStyle(
                        letterSpacing: .3,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: isSelected
                            ? SunRunColors.primary
                            : SunRunColors.white.withOpacity(1.0))),
              )
            ],
          )),
    );
  }
}
