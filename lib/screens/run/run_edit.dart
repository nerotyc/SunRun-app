
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sonnen_rennt/api/api.dart';
import 'package:sonnen_rennt/api/group.dart';
import 'package:sonnen_rennt/api/route.dart';
import 'package:sonnen_rennt/api/run.dart';
import 'package:sonnen_rennt/constants/color.dart';
import 'package:sonnen_rennt/extern/dropdownfield2.dart';
import 'package:sonnen_rennt/screens/run/run_edited.dart';
import 'package:sonnen_rennt/structs/group.dart';
import 'package:sonnen_rennt/structs/route.dart';
import 'package:sonnen_rennt/structs/run.dart';
import 'package:sonnen_rennt/widgets/run/create_edit_helper.dart';
import 'package:sonnen_rennt/widgets/sunrun_base.dart';

import 'package:sonnen_rennt/widgets/utils/error.dart';
import 'package:sonnen_rennt/widgets/utils/waiting.dart';

class RunEditScreen extends StatefulWidget {

  RunEditScreen({this.runId});

  int? runId;

  @override
  _RunEditScreenState createState() => _RunEditScreenState(
    runId: runId,
  );
}

class _RunEditScreenState extends State<RunEditScreen> {

  _RunEditScreenState({this.runId});

  int? runId;

  final _formKey = GlobalKey<FormState>();

  String _distance_str = "";
  String _elevation_str = "";
  RunType? _type = RunType.RUN;
  double? _distance = 0, _elevation_gain = 0;
  String? _group_str = null;
  String? _route_str = null;
  Duration? _duration = Duration(minutes: 5);
  DateTime? _timeStart = DateTime.now();
  String? _note = "";

  bool _waiting = false;
  late StreamController _streamController;
  late StreamSink _streamSink;
  Stream? _streamOut;

  void _clickEdit() async {
    if(_waiting) return;

    _waiting = true;
    _streamSink.add(true);

    if (_formKey.currentState!.validate()) {
      int? routeId;
      int? groupId;

      if(_route_str != null) {
        String routeIdStr = _route_str!.split(":").first;
        routeId = routeIdStr != null ? int.parse(routeIdStr) : null;
      }

      if(_group_str != null) {
        String groupIdStr = _group_str!.split(":").first;
        groupId = groupIdStr != null ? int.parse(groupIdStr) : null;
      }

      print("_route: " + routeId.toString());
      print("_distance: " + _distance.toString());
      print("_elevation_gain: " + _elevation_gain.toString());
      print("_type: " + _type.toString());
      print("_time_start: " + _timeStart.toString());
      print("_duration: " + _duration.toString());
      print("_group: " + groupId.toString());
      print("_note: " + _note!);

      Run run = Run.createNew(
        id: runId,
        route_id: routeId,
        distance: _distance,
        elevation_gain: _elevation_gain,
        type: _type,
        time_start: _timeStart,
        duration: _duration,
        group_id: groupId,
        note: _note,
      );

      RunEditResult res = await RunApi.runEdit(run);

      if (res.type == RunEditResultType.SUCCESS_200) {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => RunEditedScreen()));
      } else {
        final snackBar = SnackBar(
          content: Text("Error: " + res.detail!,
              style: TextStyle(color: Colors.white)
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    _waiting = false;
    _streamSink.add(true);
  }

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
    var inputBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(50.0),
        gapPadding: 2.0
    );

    return SunRunBaseWidget(
      title: "Aktivität bearbeiten",
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
            future: Future.sync(() async {
              Future<RunDetailResult> future_run = RunApi.runDetail(runId);
              Future<RouteListResult> future_routes = RouteApi.routeList();
              Future<GroupListResult> future_groups = GroupApi.groupList();
              RunDetailResult runResult = await future_run;
              RouteListResult routesResult = await future_routes;
              GroupListResult groupsResult = await future_groups;

              if (runResult.type != RunDetailResultType.SUCCESS_200)
                return runResult.detail;

              if (routesResult.type != RouteListResultType.SUCCESS_200)
                return routesResult.detail;

              if (groupsResult.type != GroupListResultType.SUCCESS_200)
                return groupsResult.detail;

              Run? run = runResult.run;
              List<DJKRoute> routeList = routesResult.routes;
              List<Group> groupList = groupsResult.groups;

              List<String> routeStringList = [];
              for (DJKRoute route in routeList) {
                routeStringList.add(route.id.toString() + ": " + route.title.toString() + " (" + route.distance.toString() + "km)");
              }

              List<String> groupStringList = [];
              for (Group group in groupList) {
                groupStringList.add(group.id.toString() + ": " + group.name.toString());
              }

              return {
                'run': run,
                'routeList': routeStringList,
                'groupList': groupStringList,
              };
            }),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
              if(snap.hasError || (snap.hasData && (snap.data is String))) {
                return SrErrorWidget(
                  description: snap.error.toString(),
                );
              }

              if (snap.connectionState == ConnectionState.waiting) {
                return SrWaitingWidget();
              }
              if(snap.hasData && snap.data != null) {
                Run run = snap.data['run'];
                var routeList = snap.data['routeList'];
                var groupList = snap.data['groupList'];

                _distance_str = run.distance.toString();
                _elevation_str = run.elevation_gain.toString();
                _type = run.type;
                _distance = run.distance;
                _elevation_gain = run.elevation_gain;
                _duration = run.duration;
                _timeStart = run.time_start;
                _note = run.note;

                _route_str = null;
                if(run.route_id != null) {
                  for (String routeStr in routeList) {
                    if (routeStr.startsWith(run.route_id.toString() + ": "))
                      _route_str = routeStr;
                  }
                  if (_route_str == null)
                    _route_str = run.route_id.toString();
                }

                _group_str = null;
                if(run.group_id != null) {
                  for (String groupStr in groupList) {
                    if (groupStr.startsWith(run.group_id.toString() + ": "))
                      _group_str = groupStr;
                  }
                  if (_group_str == null)
                    _group_str = run.group_id.toString();
                }

                Column col = Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 32),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Neue Aktivität",
                            style: TextStyle(
                                color: Colors.white,
                                // color: SunRunColors.text,
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      ),
                    ),
                    SizedBox(height: 14,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white),
                              ),
                              child: DropDownField(
                                controller: TextEditingController(text: _route_str),
                                items: routeList,
                                value: _route_str,
                                labelText: 'Route',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                labelStyle: TextStyle(color: Colors.white,), // heading
                                textStyle: TextStyle(color: Colors.white,),
                                hintText: "Textsuche",
                                icon: Icon(Icons.directions_run, color: Colors.white,),
                                setter: (newValue) {
                                  print("++++++++++++++++++++++++ ON CHANGE 2 +++++++++++++++++");
                                },
                                onValueChanged: (val) {
                                  print("++++++++++++++++++++++++ ON CHANGE +++++++++++++++++");
                                  _route_str = val;
                                },
                              ),
                            ),
                            SizedBox(height: 16,),
                            TextFormField(
                              controller: TextEditingController(text: _distance_str),
                              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                              onChanged: (String value) {
                                try {
                                  double parsed = double.parse(value.replaceAll(",", "."));
                                  _distance = parsed;
                                } on Exception {
                                  _distance = 0;
                                }
                                _distance_str = _distance.toString();
                              },
                              validator: (value) {
                                if  (_route_str != null && _route_str!.isNotEmpty) {
                                  return null;
                                }
                                if (value == null || value.isEmpty) {
                                  return "Distanz darf nur leer sein, wenn eine Route gewählt wird.";
                                }
                                try {
                                  double doubleValue = double.parse(value);
                                  if(doubleValue > 10000) {
                                    return "Zu großer Wert!";
                                  }
                                } on Exception {
                                  return "Falsch formatierter Wert!";;
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.white
                              ),
                              decoration: InputDecoration(
                                enabledBorder: inputBorder,
                                border: inputBorder,
                                prefixIcon: Icon(Icons.map, size: 20, color: SunRunColors.djk_heading,),
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                hintText: 'Distanz (z.B. 12.2)',
                                // labelText: '',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(height: 16,),
                            // -----

                            // MultiSelectFormField(
                            //   autovalidate: AutovalidateMode.always,
                            //   chipBackGroundColor: Colors.red,
                            //   chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                            //   dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                            //   checkBoxActiveColor: Colors.red,
                            //   checkBoxCheckColor: Colors.green,
                            //   dialogShapeBorder: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.all(Radius.circular(12.0))),
                            //   title: Text(
                            //     "Aktivitätstyp",
                            //     style: TextStyle(fontSize: 16),
                            //   ),
                            //   dataSource: Run.getRunTypeFormListMap(),
                            //   textField: 'display',
                            //   valueField: 'value',
                            //   okButtonLabel: 'OK',
                            //   cancelButtonLabel: 'Abbrechen',
                            //   // initialValue: Run.stringType(_type),
                            //   onSaved: (value) {
                            //     _type = Run.parseType(value);
                            //   },
                            // ),
                            // SizedBox(height: 16,),

                            TextFormField(
                              controller: TextEditingController(text: _elevation_str),
                              keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                              onChanged: (String value) {
                                try {
                                  double parsed = double.parse(value.replaceAll(",", "."));
                                  _elevation_gain = parsed;
                                } on Exception {
                                  _elevation_gain = 0;
                                }
                                _elevation_str = _elevation_gain.toString();
                              },
                              style: TextStyle(
                                  color: Colors.white
                              ),
                              validator: (value) {
                                if ((value == null || value.isEmpty)) {
                                  return null;
                                }
                                try {
                                  double doubleValue = double.parse(value);
                                  if(doubleValue > 10000) {
                                    return "Zu großer Wert!";
                                  }
                                } on Exception {
                                  return "Falsch formatierter Wert!";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                enabledBorder: inputBorder,
                                border: inputBorder,
                                prefixIcon: Icon(Icons.landscape, size: 20, color: SunRunColors.djk_heading,),
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                hintText: 'Höhenmeter (z.B. 123.2)',
                                // labelText: '',
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(height: 16,),
                            RadioTileGroupWidget(
                              value: _type,
                              setGlobalType: (RunType t) {
                                _type = t;
                              },
                            ),
                            SizedBox(height: 16,),
                            BasicDateTimeField(
                              value: _timeStart,
                              setValue: (DateTime dateTime) {
                                _timeStart = dateTime;
                              },
                            ),
                            SizedBox(height: 16,),
                            BasicDurationField(
                              value: _duration,
                              setValue: (Duration d) {
                                _duration = d;
                              },
                            ),
                            SizedBox(height: 16,),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white),
                              ),
                              child: DropDownField(
                                controller: TextEditingController(text: _group_str),
                                // items: Run.getRunTypeFormList(),
                                items: groupList,
                                value: _group_str,
                                labelText: 'Gruppe',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                labelStyle: TextStyle(color: Colors.white,), // heading
                                textStyle: TextStyle(color: Colors.white,),
                                hintText: "Textsuche",
                                icon: Icon(Icons.directions_run, color: Colors.white,),
                                onValueChanged: (val) {
                                  _group_str = val;
                                },
                              ),
                            ),
                            SizedBox(height: 16,),
                            TextFormField(
                              controller: TextEditingController(text: _note),
                              keyboardType: TextInputType.multiline,
                              onChanged: (String value) {
                                _note = value;
                              },
                              style: TextStyle(
                                  color: Colors.white
                              ),
                              minLines: 1,
                              maxLines: 14,
                              decoration: InputDecoration(
                                enabledBorder: inputBorder,
                                border: inputBorder,
                                prefixIcon: Icon(Icons.label, size: 20, color: SunRunColors.djk_heading,),
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                fillColor: Colors.white,
                                hintMaxLines: 10,
                                hintText: 'Notiz',
                                // labelText: '',
                              ),
                            ),
                            SizedBox(height: 36,),
                            StreamBuilder(
                              stream: _streamOut,
                              builder: (ctx, snap) {
                                if (_waiting) return SrWaitingWidget();
                                return ElevatedButton(
                                  onPressed: _clickEdit,
                                  child: Text("Bearbeiten"),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
                return col;
              }
              return Text("ERROR");
            },
          ),
        ],
      ),
    );
  }
}
