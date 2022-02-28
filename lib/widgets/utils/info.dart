
import 'package:flutter/material.dart';
import 'package:sonnen_rennt/constants/color.dart';
import 'package:sonnen_rennt/widgets/utils/notification.dart';


class SrInfoWidget extends SrNotificationBaseWidget {

  SrInfoWidget({
    String title = "Fehler",
    String description = "Unspezifierter Fehler",
    SrNotificationWidgetSize size = SrNotificationWidgetSize.LARGE,
    bool fillWindow = false,
  }) : super(
    title: title,
    description: description,
    size: size,
    iconColor: SunRunColors.info,
    icon: Icons.info,
    fillWindow: fillWindow,
  );
}
