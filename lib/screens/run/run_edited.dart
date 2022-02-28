

import 'package:flutter/material.dart';
import 'package:sonnen_rennt/widgets/sunrun_base.dart';
import 'package:sonnen_rennt/widgets/utils/info.dart';
import 'package:sonnen_rennt/widgets/utils/notification.dart';

class RunEditedScreen extends StatefulWidget {
  @override
  _RunEditedScreenState createState() => _RunEditedScreenState();
}

class _RunEditedScreenState extends State<RunEditedScreen> {
  @override
  Widget build(BuildContext context) {
    return SunRunBaseWidget(
      title: "Lauf bearbeitet!",
      child: SrInfoWidget(
        title: "Lauf bearbeitet!",
        description: "",
        size: SrNotificationWidgetSize.LARGE,
        fillWindow: true,
      ),
    );
  }
}
