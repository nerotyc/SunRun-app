

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sonnen_rennt/api/api.dart';
import 'package:sonnen_rennt/api/route.dart';
import 'package:sonnen_rennt/constants/color.dart';
import 'package:sonnen_rennt/structs/route.dart';
import 'package:sonnen_rennt/widgets/sunrun_base.dart';
import 'package:sonnen_rennt/widgets/utils/error.dart';
import 'package:sonnen_rennt/widgets/utils/waiting.dart';

import 'package:url_launcher/url_launcher.dart';

// TODO hide delete edit icons if not equal creator_id

class RouteListScreen extends StatefulWidget {

  RouteListScreen({this.onlyLoggedInUsers = true});

  bool onlyLoggedInUsers = true;

  @override
  _RouteListScreenState createState() => _RouteListScreenState(
      onlyLoggedInUsers: onlyLoggedInUsers,
  );
}

class _RouteListScreenState extends State<RouteListScreen> {

  _RouteListScreenState({this.onlyLoggedInUsers});

  bool? onlyLoggedInUsers = true;

  @override
  Widget build(BuildContext context) {
    return SunRunBaseWidget(
        title: onlyLoggedInUsers! ? "Meine Routen" : "Alle Routen",
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 32),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Liste",
                    style: TextStyle(
                        color: Colors.white,
                        // color: SunRunColors.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
              ),
            ),
            SizedBox(height: 14,),
            FutureBuilder(
              future: onlyLoggedInUsers!
                  ? RouteApi.routeListUser()
                  : RouteApi.routeList(),
              builder: (context, AsyncSnapshot<RouteListResult> snap) {
                if(snap.hasError || (snap.hasData && snap.data != null
                    && snap.data!.type != RouteListResultType.SUCCESS_200)) {
                  return SrErrorWidget(
                    description: snap.data!.detail,
                  );
                }

                if (snap.connectionState == ConnectionState.waiting) {
                  return SrWaitingWidget();
                }

                if(snap.hasData &&
                    snap.data!.type == RouteListResultType.SUCCESS_200) {
                  RouteListResult res = snap.data!;
                  List<DJKRoute> routes = res.routes;

                  return Container(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: ListView(
                        shrinkWrap: true,
                        children: new List.generate(routes.length+1, (index) {
                          if (index == routes.length)
                            return SizedBox(height: 200,);
                          if (routes[index] == null) return SizedBox();

                          DJKRoute route = routes[index];
                          return RouteListCardWidget(
                            route: route,
                            onlyLoggedInUsers: onlyLoggedInUsers,
                          );
                        }).toList(),
                      )
                  );
                }
                return Text("ERROR");
              }
            )
          ],
        ),
    );
  }
}

class RouteListCardWidget extends StatefulWidget {

  RouteListCardWidget({this.route, this.onlyLoggedInUsers});

  DJKRoute? route;
  bool? onlyLoggedInUsers = true;

  @override
  _RouteListCardWidgetState createState() =>
      _RouteListCardWidgetState(
          route: route,
          onlyLoggedInUsers: onlyLoggedInUsers
      );
}

class _RouteListCardWidgetState extends State<RouteListCardWidget> {

  _RouteListCardWidgetState({this.route, this.onlyLoggedInUsers});

  DJKRoute? route;
  bool? onlyLoggedInUsers = true;

  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: (){
        setState(() {
          toggle = !toggle;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.0),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          color: SunRunColors.djk_bg_dark,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Text(route!.title!,
                          style: TextStyle(color: SunRunColors.djk_heading, fontSize: 18, fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
                SizedBox(height: 12,),
                // Builder(
                //   builder: (ctx) {
                //     if (!onlyLoggedInUsers) {
                //       return Column(
                //         children: [
                //           Row(
                //             children: [
                //               Text("Ersteller: ", style: TextStyle(color: SunRunColors.djk_heading, fontWeight: FontWeight.bold),),
                //               Text(route.distance.toString() + "km / " + route.elevationGain.toString() + "m", style: TextStyle(color: SunRunColors.djk_heading),),
                //             ],
                //           ),
                //           SizedBox(height: 12,),
                //         ],
                //       );
                //     }
                //     return SizedBox(height: 0, width: 1,);
                //   },
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Distanz/Höhenmeter: ", style: TextStyle(color: SunRunColors.djk_heading, fontWeight: FontWeight.bold),),
                    Text(route!.distance.toString() + "km / " + route!.elevationGain.toString() + "m", style: TextStyle(color: SunRunColors.djk_heading),),
                  ],
                ),
                SizedBox(height: 8,),
                Builder(
                  builder: (context) {
                    if (route!.link != null && route!.link!.length > 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Link: ", style: TextStyle(color: SunRunColors.djk_heading, fontWeight: FontWeight.bold),),
                          InkWell(
                              child: Text(route!.link!, style: TextStyle(color: SunRunColors.primary,)),
                              onTap: () => launch(route!.link!)
                          ),
                        ],
                      );
                    }
                    return SizedBox(width: 1, height: 1,);
                  },
                ),
                SizedBox(height: 8,),
                Builder(
                  builder: (context) {
                    // TODO tools
                    if (toggle) {
                      if (route!.description != null && route!.description!.length > 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8,),
                            SizedBox(height: 8,),
                            Text("Beschreibung: ", style: TextStyle(color: SunRunColors.djk_heading, fontWeight: FontWeight.bold),),
                            SizedBox(height: 8,),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text(route!.description!, style: TextStyle(color: SunRunColors.djk_heading), maxLines: 10,),
                            )
                          ],
                        );
                      }
                      return SizedBox(width: 1, height: 1,);
                    } else {
                      return SizedBox(width: 1, height: 1,);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
