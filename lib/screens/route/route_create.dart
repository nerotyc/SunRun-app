
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sonnen_rennt/api/api.dart';
import 'package:sonnen_rennt/api/route.dart';
import 'package:sonnen_rennt/constants/color.dart';
import 'package:sonnen_rennt/screens/route/route_created.dart';
import 'package:sonnen_rennt/structs/route.dart';
import 'package:sonnen_rennt/widgets/sunrun_base.dart';

import 'package:sonnen_rennt/widgets/utils/waiting.dart';


class RouteCreateScreen extends StatefulWidget {

  @override
  _RouteCreateScreenState createState() => _RouteCreateScreenState();

}

class _RouteCreateScreenState extends State<RouteCreateScreen> {

  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _distanceStr = "";
  String _elevationGainStr = "";
  double _distance = 0, _elevationGain = 0;
  String _link = null;
  String _description = null;

  bool _waiting = false;
  StreamController _streamController;
  StreamSink _streamSink;
  Stream _streamOut;

  void _clickCreate() async {
    if(_waiting) return;

    _waiting = true;
    _streamSink.add(true);

    if (_formKey.currentState.validate()) {

      print("_title: " + _title);
      print("_distance: " + _distance.toString());
      print("_elevationGain: " + _elevationGain.toString());
      print("_link: " + _link);
      print("_description: " + _description);

      DJKRoute route = DJKRoute.createNew(
        title: _title,
        distance: _distance,
        elevationGain: _elevationGain,
        link: _link,
        description: _description
      );

      RouteCreateResult res = await RouteApi.routeCreate(route);

      if (res.type == RouteCreateResultType.SUCCESS_200) {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => RouteCreatedScreen()));
        print("Created route!");
      } else {
        final snackBar = SnackBar(
            content: Text("Error: " + res.detail,
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
        gapPadding: 2.0,
    );

    return SunRunBaseWidget(
      title: "Route erstellen",
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 32),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Neue Route",
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
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: TextEditingController(text: _title),
                    keyboardType: TextInputType.multiline,
                    onChanged: (String value) {
                      _title = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Titel darf nicht leer sein.";
                      }
                      return null;
                    },
                    style: TextStyle(
                        color: Colors.white
                    ),
                    minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      enabledBorder: inputBorder,
                      border: inputBorder,
                      prefixIcon: Icon(Icons.label, size: 20, color: SunRunColors.djk_heading,),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      fillColor: Colors.white,
                      hintMaxLines: 10,
                      hintText: 'Titel',
                      // labelText: '',
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: TextEditingController(text: _distanceStr),
                    keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
                    onChanged: (String value) {
                      try {
                        double parsed = double.parse(value.replaceAll(",", "."));
                        _distance = parsed;
                      } on Exception {
                        _distance = 0;
                      }
                      _distanceStr = _distance.toString();
                      return value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Distanz darf nicht leer sein.";
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
                  TextFormField(
                    controller: TextEditingController(text: _elevationGainStr),
                    keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                    onChanged: (String value) {

                      try {
                        double parsed = double.parse(value.replaceAll(",", "."));
                        _elevationGain = parsed;
                      } on Exception {
                        _elevationGain = 0;
                      }
                      _elevationGainStr = _elevationGain.toString();
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
                  TextFormField(
                    controller: TextEditingController(text: _link),
                    keyboardType: TextInputType.multiline,
                    onChanged: (String value) {
                      _link = value;
                    },
                    style: TextStyle(
                        color: Colors.white
                    ),
                    minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      enabledBorder: inputBorder,
                      border: inputBorder,
                      prefixIcon: Icon(Icons.label, size: 20, color: SunRunColors.djk_heading,),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      fillColor: Colors.white,
                      hintMaxLines: 10,
                      hintText: 'Link',
                      // labelText: '',
                    ),
                  ),
                  SizedBox(height: 16,),
                  TextFormField(
                    controller: TextEditingController(text: _description),
                    keyboardType: TextInputType.multiline,
                    onChanged: (String value) {
                      _description = value;
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
                      hintText: 'Beschreibung',
                      // labelText: '',
                    ),
                  ),
                  SizedBox(height: 36,),
                  StreamBuilder(
                    stream: _streamOut,
                    builder: (ctx, snap) {
                      if (_waiting) return SrWaitingWidget();
                      return ElevatedButton(
                        onPressed: _clickCreate,
                        child: Text("Erstellen"),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
