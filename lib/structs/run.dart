

import 'package:flutter/material.dart';

class Run {

  Run(
    this.id, this.creator_id, this.distance, this.time_start,
    this.duration, this.type, this.note,
    this.group_id, this.route_id, this.elevation_gain,
  );

  Run.createNew({
    this.id, this.distance, this.time_start,
    this.duration, this.type, this.note,
    this.group_id, this.route_id, this.elevation_gain,
  });

  int id;
  int creator_id;
  double distance;
  DateTime time_start;
  Duration duration;
  RunType type;
  String note;
  int group_id;
  int route_id;
  double elevation_gain;

  Map<String, String> toMap() {
    Map<String, String> map = <String, String> {
      'distance': distance.toString(),
      'elevation_gain': elevation_gain.toString(),
      'type': stringType(type),
      'time_start': time_start.toString().replaceAll("Z", ""),
      'duration': duration.inMicroseconds.toString(),
    };

    if (note != null && note.isNotEmpty) {
      map.addAll({ 'note': note.toString() });
    }

    if (route_id != null && route_id > 0) {
      map.addAll({ 'route_id': route_id.toString() });
    }

    if (group_id != null && group_id > 0) {
      map.addAll({ 'group_id': group_id.toString() });
    }

    return map;
  }

  factory Run.fromJson(Map json) {
    print("run.fromJson");

    try {
      int id = int.parse(json["id"].toString());
      int creatorId = int.parse(json['creator_id'].toString());
      double distance = double.parse(json['distance'].toString());
      DateTime dateTime = DateTime.parse(json['time_start'].toString());

      String durationStr = json['duration'];
      var split1 = durationStr.split(".");

      int length = split1.length;
      if (length <= 0) return null;

      var split2 = split1.first.split(":");
      int hours = int.parse(split2.first);
      int mins = int.parse(split2[1]);
      int secs = int.parse(split2[2]);

      int micros = 0;
      if (length >= 2) micros = int.parse(split1.last);

      Duration duration = Duration(
        hours: hours,
        minutes: mins,
        seconds: secs,
        microseconds: micros,
      );
      RunType type = parseType(json['type']);
      String note = (json['note'] ?? "").toString();
      int routeId;
      if (json['route_id'] == null || json['route_id'].toString() == "null") {
        routeId = null;
      } else {
        routeId = int.parse(json['route_id'].toString());
      }

      int groupId;
      if (json['group_id'] == null || json['group_id'].toString() == "null") {
        groupId = null;
      } else {
        groupId = int.parse(json['group_id'].toString());
      }
      double elevationGain = double.parse((json['elevation_gain'] ?? "0").toString());

      return Run(
        id, creatorId, distance, dateTime, duration, type,
        note, groupId, routeId, elevationGain
      );
    } on Exception catch(ex) {
      print(ex.toString());
      return null;
    } on Error catch(err) {
      print(err.toString());
      return null;
    }
  }

  factory Run.example() {
    return Run(
      -1,
      1,
      4.2,
      DateTime.now(),
      Duration(hours: 1, minutes: 23, seconds: 54),
      RunType.BIKE,
      "notenotenote",
      1,
      1,
      192
    );
  }

  String get startTimeFormatted {
    return _twoDigit(time_start.day) + "-"
        + _twoDigit(time_start.month) + "-"
        + _twoDigit(time_start.year) + " "
        + _twoDigit( time_start.hour) + ":"
        + _twoDigit(time_start.minute) + ":"
        + _twoDigit(time_start.second);
  }

  String get durationFormatted {
    List<String> hms = duration.toString().split(".").first.split(":");
    return hms[0] + "h " + hms[1] + "min " + hms[0] + "s";
  }

  String _twoDigit(var num) {
    String numStr = num.toString();
    if (numStr.length < 2) {
      numStr = "0" + numStr;
    }
    return numStr;
  }

  IconData get typeIconData {
    if (type == "WALK") return Icons.directions_walk;
    else if (type == "BIKE") return Icons.directions_bike;
    else if (type == "E-BIKE") return Icons.electric_bike;
    else return Icons.directions_walk;
  }

  static List<Map<String, dynamic>> getRunTypeFormListMap() {
    return [
      {
        "display": "Gehen/Walken",
        "value": stringType(RunType.WALK),
      },
      {
        "display": "Laufen",
        "value": stringType(RunType.RUN),
      },
      {
        "display": "Rad",
        "value": stringType(RunType.BIKE),
      },
      {
        "display": "E-Bike",
        "value": stringType(RunType.E_BIKE),
      },
    ];
  }

  static List<String> getRunTypeFormList() {
    return [
      getTypeTitle(RunType.WALK),
      getTypeTitle(RunType.RUN),
      getTypeTitle(RunType.BIKE),
      getTypeTitle(RunType.E_BIKE),
    ];
  }

  static RunType parseType(String str) {
    switch (str.toUpperCase()) {
      case "WALK": return RunType.WALK;
      case "RUN": return RunType.RUN;
      case "BIKE": return RunType.BIKE;
      case "E-BIKE": return RunType.E_BIKE;
    }
    return RunType.RUN;
  }

  static RunType parseTypeFromTitle(String str) {
    switch (str.toUpperCase()) {
      case "Gehen/Walken": return RunType.WALK;
      case "Laufen": return RunType.RUN;
      case "Rad": return RunType.BIKE;
      case "E-Bike": return RunType.E_BIKE;
    }
    return RunType.RUN;
  }

  static String stringType(RunType type) {
    switch (type) {
      case RunType.WALK: return "WALK";
      case RunType.RUN: return "RUN";
      case RunType.BIKE: return "BIKE";
      case RunType.E_BIKE: return "E-BIKE";
    }
    return "RUN";
  }

  static String getTypeTitle(RunType type) {
    switch (type) {
      case RunType.WALK: return "Gehen/Walken";
      case RunType.RUN: return "Laufen";
      case RunType.BIKE: return "Rad";
      case RunType.E_BIKE: return "E-Bike";
    }
    return "Laufen";
  }

}

enum RunType {
  WALK,
  RUN,
  BIKE,
  E_BIKE
}