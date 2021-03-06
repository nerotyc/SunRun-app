import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sonnen_rennt/constants/color.dart';
import 'package:sonnen_rennt/constants/theme.dart';
import 'package:sonnen_rennt/root.dart';

void main() {
  runApp(SunRunApp());
}

class SunRunApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      systemNavigationBarColor: SunRunColors.djk_bg_darker
    ));

    return MaterialApp(
      title: 'SunRun',
      theme: sunRunThemeBasic(),
      debugShowCheckedModeBanner: false,
      // ThemeData(
      //   primarySwatch: Colors.orange,
      // )
      home: MyHomePage(title: 'SunRun'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return SunRunRootWidget();
  }
}
