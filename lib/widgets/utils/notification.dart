
import 'package:flutter/material.dart';
import 'package:sonnen_rennt/constants/color.dart';


enum SrNotificationWidgetSize {
  SMALL,
  MEDIUM,
  LARGE,
  XL,
}

class SrNotificationSizeHelper {
  static double getIconSize(SrNotificationWidgetSize size) {
    switch(size) {
      case SrNotificationWidgetSize.SMALL: return 20;
      case SrNotificationWidgetSize.MEDIUM: return 32;
      case SrNotificationWidgetSize.LARGE: return 64;
      case SrNotificationWidgetSize.XL: return 100;
      return 20;
    }
  }
  static double getTitleSize(SrNotificationWidgetSize size) {
    switch(size) {
      case SrNotificationWidgetSize.SMALL: return 14;
      case SrNotificationWidgetSize.MEDIUM: return 18;
      case SrNotificationWidgetSize.LARGE: return 32;
      case SrNotificationWidgetSize.XL: return 46;
      return 18;
    }
  }
  static double getTextSize(SrNotificationWidgetSize size) {
    switch(size) {
      case SrNotificationWidgetSize.SMALL: return 10;
      case SrNotificationWidgetSize.MEDIUM: return 13;
      case SrNotificationWidgetSize.LARGE: return 18;
      case SrNotificationWidgetSize.XL: return 22;
      return 13;
    }
  }
}


class SrNotificationBaseWidget extends StatelessWidget {

  SrNotificationBaseWidget({
    this.title = "Fehler",
    this.description = "Unspezifierter Fehler",
    this.size = SrNotificationWidgetSize.LARGE,
    this.icon = Icons.info,
    this.iconColor = SunRunColors.white,
    this.fillWindow = false,
  });

  final String title;
  final String? description;
  final SrNotificationWidgetSize size;
  final IconData icon;
  final Color iconColor;
  final bool fillWindow;

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * (fillWindow ? 0.25 : 0.05),),
          Icon(icon, color: iconColor,
            size: SrNotificationSizeHelper.getIconSize(size),),
          SizedBox(height: 12,),
          Text(title, style: TextStyle(
              fontSize: SrNotificationSizeHelper.getTitleSize(size)),
          ),
          SizedBox(height: 10,),
          Text(description!, style: TextStyle(
              fontSize: SrNotificationSizeHelper.getTextSize(size)),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
        ],
      ),
    );
  }
}
