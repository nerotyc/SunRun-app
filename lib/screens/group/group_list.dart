
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sonnen_rennt/api/api.dart';
import 'package:sonnen_rennt/api/group.dart';
import 'package:sonnen_rennt/constants/color.dart';
import 'package:sonnen_rennt/structs/group.dart';
import 'package:sonnen_rennt/widgets/sunrun_base.dart';
import 'package:sonnen_rennt/widgets/utils/error.dart';
import 'package:sonnen_rennt/widgets/utils/waiting.dart';

class GroupListScreen extends StatefulWidget {

  GroupListScreen({this.onlyLoggedInUsers = true});

  bool onlyLoggedInUsers = true;

  @override
  _GroupListScreenState createState() {
    return _GroupListScreenState(
        onlyLoggedInUsers: onlyLoggedInUsers,
    );
  }
}

class _GroupListScreenState extends State<GroupListScreen> {

  _GroupListScreenState({this.onlyLoggedInUsers});

  bool? onlyLoggedInUsers = true;

  void updateList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SunRunBaseWidget(
      title: onlyLoggedInUsers! ? "Meine Gruppen" : "Alle Gruppen",
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
                  ? GroupApi.groupListUser()
                  : GroupApi.groupList(),
              builder: (
                  BuildContext context,
                  AsyncSnapshot<GroupListResult> snap) {
                // TODO waiting & error

                if(snap.hasError || (snap.hasData && snap.data != null
                    && snap.data!.type != GroupListResultType.SUCCESS_200)) {
                  return SrErrorWidget(
                    description: snap.data!.detail,
                  );
                }

                if (snap.connectionState == ConnectionState.waiting) {
                  return SrWaitingWidget();
                }

                if(snap.hasData && snap.data != null &&
                    snap.data!.type == GroupListResultType.SUCCESS_200) {
                  GroupListResult res = snap.data!;
                  List<Group> groups = res.groups;

                  return Container(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: ListView(
                        shrinkWrap: true,
                        children: new List.generate(groups.length+1, (index) {
                          if (index == groups.length)
                            return SizedBox(height: 200,);
                          if (groups[index] == null) return SizedBox();

                          Group group = groups[index];
                          return GroupListCardWidget(
                            group: group,
                            onlyLoggedInUsers: onlyLoggedInUsers,
                          );
                        }).toList(),
                      )
                  );
                }
                return Text("ERROR");
                // if(snap.hasData && !snap.hasError) {
                //   return Container(
                //     height: MediaQuery.of(context).size.height * 0.85,
                //     child: ListView(
                //       shrinkWrap: true,
                //       children: new List.generate(snap.data.length+1, (index) {
                //         if (index == snap.data.length) {
                //           return SizedBox(height: 200,);
                //         }
                //         Group? group = snap.data[index];
                //         print("route: " + group.toString());
                //         return GroupListCardWidget(
                //           group: group,
                //           onlyLoggedInUsers: onlyLoggedInUsers,
                //         );
                //       }).toList(),
                //     ),
                //   );
                // }
                // return Container(
                //   height: 1,
                // );
              }
          )
        ],
      ),
    );
  }
}

class GroupListCardWidget extends StatefulWidget {

  GroupListCardWidget({this.group, this.onlyLoggedInUsers});

  Group? group;
  bool? onlyLoggedInUsers = true;

  @override
  _GroupListCardWidgetState createState() =>
      _GroupListCardWidgetState(
          group: group,
          onlyLoggedInUsers: onlyLoggedInUsers
      );
}

class _GroupListCardWidgetState extends State<GroupListCardWidget> {

  _GroupListCardWidgetState({this.group, this.onlyLoggedInUsers});

  Group? group;
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
                        child: Text(group!.name!,
                          style: TextStyle(color: SunRunColors.djk_heading, fontSize: 18, fontWeight: FontWeight.bold),)
                    ),
                  ],
                ),
                SizedBox(height: 12,),
                Row(
                  children: [
                    Text("Score: ", style: TextStyle(color: SunRunColors.djk_heading, fontWeight: FontWeight.bold),),
                    Text(group!.score!.toStringAsFixed(2) + " Punkte", style: TextStyle(color: SunRunColors.djk_heading),),
                  ],
                ),
                SizedBox(height: 12,),
                Builder(
                  builder: (ctx) {
                    if (group!.description != null && group!.description!.length > 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Beschreibung: ",
                            style: TextStyle(color: SunRunColors.djk_heading, fontWeight: FontWeight.bold),),
                          SizedBox(height: 8,),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Text(group!.description!, style: TextStyle(color: SunRunColors.djk_heading), maxLines: 10,),
                          )
                        ],
                      );
                    }
                    return SizedBox(width: 1, height: 1,);
                  },
                ),
                SizedBox(height: 8,),
                Builder(
                  builder: (context) {
                    if (toggle) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 8,),
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              Text("Anzahl Aktivitäten: ", style: TextStyle(color: SunRunColors.djk_heading, fontWeight: FontWeight.bold),),
                              Text(group!.run_count.toString(), style: TextStyle(color: SunRunColors.djk_heading),),
                            ],
                          ),
                          SizedBox(height: 12,),
                          Row(
                            children: [
                              Text("Dauer: ", style: TextStyle(color: SunRunColors.djk_heading, fontWeight: FontWeight.bold),),
                              Text(group!.sumDurationFormatted, style: TextStyle(color: SunRunColors.djk_heading),),
                            ],
                          ),
                          SizedBox(height: 12,),
                          Row(
                            children: [
                              Text("Teilnehmerzahl: ", style: TextStyle(color: SunRunColors.djk_heading, fontWeight: FontWeight.bold),),
                              Text(group!.num_participants.toString(), style: TextStyle(color: SunRunColors.djk_heading),),
                            ],
                          ),
                          SizedBox(height: 12,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.directions_bike, color: Colors.white,),
                                  SizedBox(width: 10,),
                                  Text(group!.sum_distance_bike.toString() + "km", style: TextStyle(color: SunRunColors.djk_heading),),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.electric_bike, color: Colors.white,),
                                  SizedBox(width: 10,),
                                  Text(group!.sum_distance_ebike.toString() + "km", style: TextStyle(color: SunRunColors.djk_heading),),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 12,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.directions_run, color: Colors.white,),
                                  SizedBox(width: 10,),
                                  Text(group!.sum_distance_run.toString() + "km", style: TextStyle(color: SunRunColors.djk_heading),),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.directions_walk, color: Colors.white,),
                                  SizedBox(width: 10,),
                                  Text(group!.sum_distance_walk.toString() + "km", style: TextStyle(color: SunRunColors.djk_heading),),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
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
