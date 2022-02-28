

import 'package:flutter/material.dart';
import 'package:sonnen_rennt/widgets/sunrun_base.dart';
import 'package:sonnen_rennt/widgets/utils/info.dart';
import 'package:sonnen_rennt/widgets/utils/notification.dart';

class RouteEditedScreen extends StatefulWidget {
  @override
  _RouteEditedScreenState createState() => _RouteEditedScreenState();
}

class _RouteEditedScreenState extends State<RouteEditedScreen> {
  @override
  Widget build(BuildContext context) {
    return SunRunBaseWidget(
      title: "Route bearbeitet!",
      child: SrInfoWidget(
        title: "Route bearbeitet!",
        description: "",
        size: SrNotificationWidgetSize.LARGE,
        fillWindow: true,
      ),
    );
  }
}
