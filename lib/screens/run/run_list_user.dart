

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sonnen_rennt/api/api.dart';
import 'package:sonnen_rennt/api/run.dart';
import 'package:sonnen_rennt/constants/color.dart';
import 'package:sonnen_rennt/screens/run/run_delete.dart';
import 'package:sonnen_rennt/screens/run/run_edit.dart';
import 'package:sonnen_rennt/structs/run.dart';
import 'package:sonnen_rennt/widgets/sunrun_base.dart';
import 'package:sonnen_rennt/widgets/utils/error.dart';
import 'package:sonnen_rennt/widgets/utils/waiting.dart';

class RunListUserScreen extends StatefulWidget {

  RunListUserScreen();

  @override
  _RunListUserScreenState createState() => _RunListUserScreenState();
}

class _RunListUserScreenState extends State<RunListUserScreen> {

  _RunListUserScreenState();

  void updateList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SunRunBaseWidget(
      title: "Meine Aktivitäten",
      child: Column(
        mainAxisSize: MainAxisSize.max,
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

          // TODO refresh on return from subpage

          FutureBuilder(
              // future: Future.delayed(Duration(seconds: 5), () {
              //   return RunListUserResult.UNKNOWN_ERROR(); // TODO
              // }),
              future: RunApi.runListUser(),
              builder: (context, AsyncSnapshot<RunListUserResult> snap) {
                if(snap.hasError ||
                    (snap.hasData && snap.data!.type != RunListUserResultType.SUCCESS_200)) {
                  return SrErrorWidget(
                    description: snap.data!.detail,
                  );
                }

                if (snap.connectionState == ConnectionState.waiting) {
                  return SrWaitingWidget();
                }

                if(snap.hasData && snap.data!.type == RunListUserResultType.SUCCESS_200) {
                  List<Run> runs = snap.data!.runs;

                  return Container(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: ListView(
                        shrinkWrap: true,
                        children: new List.generate(runs.length+1, (index) {
                          if (index == runs.length)
                            return SizedBox(height: 200,);
                          if (runs[index] == null) return SizedBox();

                          Run run = runs[index];
                          return RunListCardWidget(
                            updateList,
                            run: run,
                          );
                        }).toList(),
                      )
                  );
                }
                return Text("ERROR");
              }
          ),
        ],
      )
    );
  }

}

class RunListCardWidget extends StatefulWidget {

  RunListCardWidget(this.updateList, {this.run});

  Function updateList;
  Run? run;

  @override
  _RunListCardWidgetState createState() => _RunListCardWidgetState(
      updateList,
      run: run
  );
}

class _RunListCardWidgetState extends State<RunListCardWidget> {

  _RunListCardWidgetState(this.updateList, {this.run});

  Function updateList;
  Run? run;
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
                    Icon(run!.typeIconData, color: SunRunColors.djk_heading,),
                    SizedBox(width: 12,),
                    Text(run!.startTimeFormatted,
                      style: TextStyle(color: SunRunColors.djk_heading, fontSize: 18, fontWeight: FontWeight.bold),),
                  ],
                ),
                SizedBox(height: 12,),
                Text("Distanz/Höhenmeter: ", style: TextStyle(color: SunRunColors.djk_heading, fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(run!.distance.toString() + "km / " + run!.elevation_gain.toString() + "m", style: TextStyle(color: SunRunColors.djk_heading),),
                ),
                SizedBox(height: 8,),
                Row(
                  children: [
                    Text("Dauer: ", style: TextStyle(color: SunRunColors.djk_heading, fontWeight: FontWeight.bold),),
                    Text(run!.durationFormatted, style: TextStyle(color: SunRunColors.djk_heading),),
                  ],
                ),
                SizedBox(height: 8,),
                Builder(
                  builder: (context) {
                    if (toggle) {
                      return Column(
                        children: [
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              // IconButton(
                              //   onPressed: (){
                              //     // TODO
                              //   },
                              //   icon: Icon(Icons.info, color: Colors.white,),
                              //   color: Colors.orange,
                              //
                              //   padding: EdgeInsets.all(0.0),
                              //   iconSize: 18,
                              // ),
                              IconButton(
                                onPressed: () async {
                                  await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      RunEditScreen(
                                        runId: run!.id,
                                      )));
                                  print("Refresh...");
                                  updateList();
                                },
                                icon: Icon(Icons.edit, color: Colors.white,),
                                color: Colors.orange,

                                padding: EdgeInsets.all(0.0),
                                iconSize: 18,
                              ),
                              IconButton(
                                onPressed: () async {
                                  await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      RunDeleteScreen(
                                        runId: run!.id,
                                      )));
                                  print("Refresh...");
                                  updateList();
                                },
                                icon: Icon(Icons.delete, color: Colors.white,),
                                color: Colors.orange,

                                padding: EdgeInsets.all(0.0),
                                iconSize: 18,
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
