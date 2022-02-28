import 'package:flutter/material.dart';
import 'package:sonnen_rennt/constants/Theme.dart';
import 'package:sonnen_rennt/constants/color.dart';
import 'package:sonnen_rennt/screens/group/group_list.dart';
import 'package:sonnen_rennt/screens/route/route_create.dart';
import 'package:sonnen_rennt/screens/route/route_created.dart';
import 'package:sonnen_rennt/screens/route/route_list.dart';
import 'package:sonnen_rennt/screens/run/run_create.dart';
import 'package:sonnen_rennt/screens/run/run_list_user.dart';
import 'package:sonnen_rennt/widgets/sunrun_base.dart';

class LandingScreen extends StatefulWidget {

  LandingScreen({this.refreshAuthStatusCallback});

  Function refreshAuthStatusCallback = (){};

  @override
  _LandingScreenState createState() => _LandingScreenState(
      refreshAuthStatusCallback: refreshAuthStatusCallback
  );
}

class _LandingScreenState extends State<LandingScreen> {

  _LandingScreenState({this.refreshAuthStatusCallback});

  Function refreshAuthStatusCallback = (){};

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SunRunBaseWidget(
      title: "SunRun!",
      child: Column(children: [
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Servus & Griaß Gott!",
                style: TextStyle(
                    color: Colors.white,
                    // color: SunRunColors.text,
                    fontWeight: FontWeight.w600,
                    fontSize: 24)),
          ),
        ),
        // -------------------------
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Aktivitäten",
                style: TextStyle(
                    color: Colors.white,
                    // color: SunRunColors.text,
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RaisedButton(
              textColor: SunRunColors.white,
              color: SunRunColors.djk_accent,
              // color: SunRunColors.primary,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => RunListUserScreen()));
                // Navigator.pushReplacementNamed(context, '/home');
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 12, bottom: 12),
                  child:
                  Text("Meine Aktivitäten", style: TextStyle(fontSize: 14.0))),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: RaisedButton(
              textColor: SunRunColors.black,
              color: Colors.white,
              // color: Colors.orange,
              // color: SunRunColors.primary,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => RunCreateScreen()));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 12, bottom: 12),
                  child:
                  Text("Neue Aktivität", style: TextStyle(fontSize: 14.0))),
            ),
          ),
        ),
        // -------------------------
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Routen",
                style: TextStyle(
                    color: Colors.white,
                    // color: SunRunColors.text,
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RaisedButton(
              textColor: SunRunColors.white,
              color: SunRunColors.djk_accent,
              // color: SunRunColors.primary,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    RouteListScreen(
                      onlyLoggedInUsers: true,
                    )));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 12, bottom: 12),
                  child:
                  Text("Meine Routen", style: TextStyle(fontSize: 14.0))),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: RaisedButton(
              textColor: SunRunColors.black,
              color: Colors.white,
              // color: Colors.orange,
              // color: SunRunColors.primary,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    RouteListScreen(
                      onlyLoggedInUsers: false,
                    )));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 12, bottom: 12),
                  child:
                  Text("Alle Routen", style: TextStyle(fontSize: 14.0))),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Colors.black;
                    }
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return Colors.white;
                    }
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    RouteCreateScreen()
                ));
              },
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 12, bottom: 12),
                  child:
                  Text("Neue Route", style: TextStyle(fontSize: 14.0))),
            ),
          ),
        ),
        // -------------------------
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Gruppen",
                style: TextStyle(
                    color: Colors.white,
                    // color: SunRunColors.text,
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
          ),
        ),
        // SizedBox(
        //   width: double.infinity,
        //   child: Padding(
        //     padding: const EdgeInsets.only(top: 8),
        //     child: RaisedButton(
        //       textColor: SunRunColors.white,
        //       color: SunRunColors.djk_accent,
        //       // color: SunRunColors.primary,
        //       onPressed: () {
        //         // Respond to button press
        //         Navigator.push(context, MaterialPageRoute(builder: (context) => RunListUserScreen()));
        //         // Navigator.pushReplacementNamed(context, '/home');
        //       },
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(4.0),
        //       ),
        //       child: Padding(
        //           padding: EdgeInsets.only(
        //               left: 16.0, right: 16.0, top: 12, bottom: 12),
        //           child:
        //           Text("Meine Gruppen", style: TextStyle(fontSize: 14.0))),
        //     ),
        //   ),
        // ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RaisedButton(
              textColor: SunRunColors.white,
              color: SunRunColors.djk_accent,
              // color: Colors.white,
              // color: SunRunColors.primary,
              onPressed: () {
                // Respond to button press
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => GroupListScreen(
                      onlyLoggedInUsers: true,
                    )));
                // Navigator.pushReplacementNamed(context, '/home');
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 12, bottom: 12),
                  child:
                  Text("Meine Gruppen", style: TextStyle(fontSize: 14.0))),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: RaisedButton(
              textColor: SunRunColors.black,
              color: Colors.white,
              // color: Colors.orange,
              // color: SunRunColors.primary,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    GroupListScreen(
                      onlyLoggedInUsers: false,
                    )));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 12, bottom: 12),
                  child:
                  Text("Alle Gruppen", style: TextStyle(fontSize: 14.0))),
            ),
          ),
        ),
        // SizedBox(
        //   width: double.infinity,
        //   child: Padding(
        //     padding: const EdgeInsets.only(top: 0),
        //     child: RaisedButton(
        //       textColor: SunRunColors.black,
        //       color: Colors.white,
        //       // color: Colors.orange,
        //       // color: SunRunColors.primary,
        //       onPressed: () {
        //         // Respond to button press
        //         Navigator.pushReplacementNamed(context, '/home');
        //       },
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(4.0),
        //       ),
        //       child: Padding(
        //           padding: EdgeInsets.only(
        //               left: 16.0, right: 16.0, top: 12, bottom: 12),
        //           child:
        //           Text("Neue Gruppe", style: TextStyle(fontSize: 14.0))),
        //     ),
        //   ),
        // ),
        // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ]),
    );
  }

}
// Padding(
//   padding: const EdgeInsets.only(left: 8.0, top: 32, bottom: 32),
//   child: Align(
//     alignment: Alignment.centerLeft,
//     child: Text("Verfügbare Funktionen:",
//         style: TextStyle(fontSize: 24, color: SunRunColors.text)),
//   ),
// ),