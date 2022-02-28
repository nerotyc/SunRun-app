

import 'package:flutter/material.dart';
import 'package:sonnen_rennt/widgets/sunrun_base.dart';
import 'package:sonnen_rennt/widgets/utils/info.dart';
import 'package:sonnen_rennt/widgets/utils/notification.dart';

class RouteDeletedScreen extends StatefulWidget {
  @override
  _RouteDeletedScreenState createState() => _RouteDeletedScreenState();
}

class _RouteDeletedScreenState extends State<RouteDeletedScreen> {
  @override
  Widget build(BuildContext context) {
    return SunRunBaseWidget(
      title: "Route gelöscht!",
      child: SrInfoWidget(
        title: "Route gelöscht!",
        description: "",
        size: SrNotificationWidgetSize.LARGE,
        fillWindow: true,
      ),
    );
  }
}
