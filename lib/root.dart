

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonnen_rennt/logic/auth.dart';
import 'package:sonnen_rennt/screens/landing.dart';
import 'package:sonnen_rennt/screens/login.dart';
import 'package:sonnen_rennt/widgets/utils/waiting.dart';

class SunRunRootWidget extends StatefulWidget {
  @override
  _SunRunRootWidgetState createState() => _SunRunRootWidgetState();
}

class _SunRunRootWidgetState extends State<SunRunRootWidget> {

  @override
  void initState() {
    authHandler.tryReadSecretsAndLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: authHandler,
        ),
      ],
      child: Consumer<AuthHandler>(
        builder: (ctx, data, child) {
          if(data.isWaiting!) return SrWaitingScreen();
          if (data.isLoggedIn) return LandingScreen();
          return LoginScreen();
        },
      ),
    );
  }
}

