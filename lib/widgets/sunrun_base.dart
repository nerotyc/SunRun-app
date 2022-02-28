

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonnen_rennt/constants/color.dart';
import 'package:sonnen_rennt/logic/auth.dart';
import 'package:sonnen_rennt/screens/group/group_list.dart';
import 'package:sonnen_rennt/screens/route/route_list.dart';
import 'package:sonnen_rennt/screens/run/run_list_user.dart';
import 'package:sonnen_rennt/widgets/drawer-tile.dart';
import 'package:sonnen_rennt/widgets/utils/waiting.dart';

class SunRunBaseWidget extends StatefulWidget {

  SunRunBaseWidget({this.title = "", this.child, this.rootRoute = false})
      : super(key: UniqueKey());

  String title;
  Widget child;
  final bool rootRoute;

  @override
  _SunRunBaseWidgetState createState() => _SunRunBaseWidgetState(
    title: title,
    child: child,
    rootRoute: rootRoute,
  );
}

class _SunRunBaseWidgetState extends State<SunRunBaseWidget> {

  _SunRunBaseWidgetState({this.title, this.child, this.rootRoute}) {
    _scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  String title;
  Widget child;
  final bool rootRoute;

  GlobalKey<ScaffoldState> _scaffoldKey;

  void popWhilePossiblePushNewScreen(Widget screen) {
    while(Navigator.of(context).canPop())
      Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => screen));
  }

  @override
  void initState() {
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
        builder: (ctx, data, cld) {
          if(data.isWaiting) return SrWaitingScreen();
          if (!data.isLoggedIn) {
            while(Navigator.of(context).canPop())
              Navigator.of(context).pop();
            return Scaffold(
              body: Text(" "),
            );
          }

          return Scaffold(
            key: _scaffoldKey,
            // appBar: Navbar(
            //   title: "Components",
            // ),
            appBar: AppBar(
              leading: Navigator.of(context).canPop() ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white,),
                onPressed: () {
                  if(Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ) : null,
              actions: [
                IconButton(
                    icon: Icon(Icons.menu, color: SunRunColors.djk_heading,),
                    onPressed: (){
                      _scaffoldKey.currentState.openDrawer();
                    }
                )
              ],
              // backgroundColor: Color.fromARGB(255, 16, 16, 16),
              backgroundColor: SunRunColors.djk_bg_darker,
              // backgroundColor: Colors.deepOrangeAccent,
              automaticallyImplyLeading: Navigator.of(context).canPop(),
              title: Text(title, style: TextStyle(color: SunRunColors.djk_heading),),
              elevation: 0,
            ),
            drawer: Drawer(
              child: Container(
                color: SunRunColors.djk_bg_darker,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 15, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("SunRun!",
                                style: TextStyle(
                                    color: Colors.white,
                                    // color: SunRunColors.text,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24)),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: (){
                                  _scaffoldKey.currentState.openEndDrawer();
                                },
                                icon: Icon(Icons.close, color: SunRunColors.djk_heading,)
                            ),
                          ),
                        ],
                      ),
                    ),
                    DrawerTile(
                      title: "Meine Aktivitäten",
                      iconColor: Colors.white,
                      icon: Icons.directions_run,
                      onTap: (){
                        popWhilePossiblePushNewScreen(RunListUserScreen());
                      },
                    ),
                    DrawerTile(
                      title: "Meine Routen",
                      iconColor: Colors.white,
                      icon: Icons.group,
                      isSelected: false,
                      onTap: (){
                        popWhilePossiblePushNewScreen(RouteListScreen());
                      },
                    ),
                    DrawerTile(
                      title: "Alle Gruppen",
                      iconColor: Colors.white,
                      icon: Icons.group,
                      isSelected: false,
                      onTap: (){
                        popWhilePossiblePushNewScreen(GroupListScreen());
                      },
                    ),
                    Container(
                      child: DrawerTile(
                        title: "Abmelden",
                        iconColor: Colors.white,
                        icon: Icons.person,
                        isSelected: false,
                        onTap: (){
                          Provider.of<AuthHandler>(context, listen: false).logout();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // backgroundColor: SunRunColors.bgColorScreen,
            backgroundColor: SunRunColors.djk_bg_darker,
            // backgroundColor: Color.fromARGB(255, 36, 36, 46),
            // drawer: NowDrawer(currentPage: "Components"),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(right: 16, left: 16, bottom: 36),
                child: SafeArea(
                  // bottom: true,
                  // child: SizedBox(),
                  child: child ?? SizedBox(width: 1,),
                ),
              ),
            ),
          );

        },
      ),
    );
  }
}
