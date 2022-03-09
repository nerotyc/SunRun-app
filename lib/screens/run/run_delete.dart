
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonnen_rennt/api/api.dart';
import 'package:sonnen_rennt/api/run.dart';
import 'package:sonnen_rennt/constants/Theme.dart';
import 'package:sonnen_rennt/constants/color.dart';
import 'package:sonnen_rennt/structs/run.dart';
import 'package:sonnen_rennt/widgets/sunrun_base.dart';
import 'package:sonnen_rennt/widgets/utils/error.dart';
import 'package:sonnen_rennt/widgets/utils/waiting.dart';

class RunDeleteScreen extends StatefulWidget {

  RunDeleteScreen({this.refreshAuthStatusCallback, this.runId});

  Function? refreshAuthStatusCallback = (){};
  int? runId;

  @override
  _RunDeleteScreenState createState() => _RunDeleteScreenState(
    refreshAuthStatusCallback: refreshAuthStatusCallback,
    runId: runId,
  );

}

class _RunDeleteScreenState extends State<RunDeleteScreen> {

  _RunDeleteScreenState({this.refreshAuthStatusCallback, this.runId});

  Function? refreshAuthStatusCallback = (){};
  int? runId;

  bool _waiting = false;
  late StreamController _streamController;
  late StreamSink _streamSink;
  Stream? _streamOut;

  @override
  void initState() {
    _streamController = StreamController();
    _streamSink = _streamController.sink;
    _streamOut = _streamController.stream;
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    _streamSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SunRunBaseWidget(
      title: "Aktivität löschen",
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
          FutureBuilder(
            future: RunApi.runDetail(runId),
            builder: (context, AsyncSnapshot<RunDetailResult> snap) {
              if(snap.hasError ||
                  (snap.hasData && snap.data!.type != RunDetailResultType.SUCCESS_200)) {
                return SrErrorWidget(
                  description: snap.data!.detail,
                );
              }

              if (snap.connectionState == ConnectionState.waiting) {
                return SrWaitingWidget();
              }

              if(snap.hasData && snap.data!.type == RunDetailResultType.SUCCESS_200) {
                Run run = snap.data!.run!;

                return Container(
                  margin: EdgeInsets.only(bottom: 12.0, top: 24.0),
                  child: Column(
                    children: [
                      Card(
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
                                  Icon(run.typeIconData, color: SunRunColors.djk_heading,),
                                  SizedBox(width: 12,),
                                  Text(run.startTimeFormatted,
                                    style: TextStyle(color: SunRunColors.djk_heading, fontSize: 18, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              SizedBox(height: 12,),
                              Text("Distanz/Höhenmeter: ", style: TextStyle(color: SunRunColors.djk_heading, fontWeight: FontWeight.bold),),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(run.distance.toString() + "km / " + run.elevation_gain.toString() + "m", style: TextStyle(color: SunRunColors.djk_heading),),
                              ),
                              SizedBox(height: 8,),
                              Row(
                                children: [
                                  Text("Dauer: ", style: TextStyle(color: SunRunColors.djk_heading, fontWeight: FontWeight.bold),),
                                  Text(run.durationFormatted, style: TextStyle(color: SunRunColors.djk_heading),),
                                ],
                              ),
                              SizedBox(height: 8,),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 14,),
                      StreamBuilder(
                        stream: _streamOut,
                        builder: (ctx, snap) {
                          if (_waiting) return SrWaitingWidget();
                          return ElevatedButton(
                            onPressed: () async {
                              if(_waiting) return;

                              _waiting = true;
                              _streamSink.add(true);

                              var res = await RunApi.runDelete(runId);
                              if(res.type == RunDeleteResultType.SUCCESS_200) {
                                Navigator.of(context).pop();
                              } else {
                                final snackBar = SnackBar(
                                  content: Text("Error: " + res.detail!,
                                      style: TextStyle(color: Colors.white)
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }

                              _waiting = false;
                              _streamSink.add(true);
                            },
                            child: Text("Löschen"),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              return Text("ERROR");






              // if(snap.hasData && !snap.hasError) {
              //   Run run = snap.data;
              //
              //   return Column(
              //     children: [
              //       SizedBox(height: 18,),

              //
              //       SizedBox(height: 36,),
              //       ElevatedButton(
              //         onPressed: () async {
              //           // TODO block input while waiting
              //           // if(await RunApi.runDelete(runId)) {
              //           //   final snackBar = SnackBar(content: Text('Löschung erfolgreich!'));
              //           //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
              //           // } else {
              //           //   final snackBar = SnackBar(content: Text('Löschung fehlgeschlagen!'));
              //           //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
              //           // }
              //         },
              //         child: Text('Löschen', style: TextStyle(color: Colors.white),),
              //       ),
              //     ],
              //   );
              //
              // }
              // return Container(
              //   margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
              //   child: Center(
              //     child: CircularProgressIndicator(),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
