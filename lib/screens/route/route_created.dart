

import 'package:flutter/material.dart';
import 'package:sonnen_rennt/widgets/sunrun_base.dart';
import 'package:sonnen_rennt/widgets/utils/info.dart';
import 'package:sonnen_rennt/widgets/utils/notification.dart';

class RouteCreatedScreen extends StatefulWidget {
  @override
  _RouteCreatedScreenState createState() => _RouteCreatedScreenState();
}

class _RouteCreatedScreenState extends State<RouteCreatedScreen> {
  @override
  Widget build(BuildContext context) {
    return SunRunBaseWidget(
      title: "Route erstellt!",
      child: SrInfoWidget(
        title: "Route erstellt!",
        description: "",
        size: SrNotificationWidgetSize.LARGE,
        fillWindow: true,
      ),
    );
  }
}
