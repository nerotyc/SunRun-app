

import 'package:flutter/material.dart';
import 'package:sonnen_rennt/widgets/sunrun_base.dart';
import 'package:sonnen_rennt/widgets/utils/info.dart';
import 'package:sonnen_rennt/widgets/utils/notification.dart';

class RunCreatedScreen extends StatefulWidget {
  @override
  _RunCreatedScreenState createState() => _RunCreatedScreenState();
}

class _RunCreatedScreenState extends State<RunCreatedScreen> {
  @override
  Widget build(BuildContext context) {
    return SunRunBaseWidget(
      title: "Lauf erstellt!",
      child: SrInfoWidget(
        title: "Lauf erstellt!",
        description: "",
        size: SrNotificationWidgetSize.LARGE,
        fillWindow: true,
      ),
    );
  }
}
