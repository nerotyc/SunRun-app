
import 'package:flutter/material.dart';
import 'package:sonnen_rennt/constants/color.dart';
import 'package:sonnen_rennt/widgets/utils/notification.dart';


class SrErrorWidget extends SrNotificationBaseWidget {

  SrErrorWidget({
    String title = "Fehler",
    String description = "Unspezifierter Fehler",
    SrNotificationWidgetSize size = SrNotificationWidgetSize.LARGE,
    bool fillWindow = false,
  }) : super(
    title: title,
    description: description,
    size: size,
    iconColor: SunRunColors.error,
    icon: Icons.error,
    fillWindow: fillWindow,
  );

}
