
class DJKRoute {

  DJKRoute(
      this.id, this.title, this.distance, this.elevationGain,
      this.description, this.link, this.creatorId
  );

  DJKRoute.createNew({
    this.title, this.distance, this.elevationGain,
    this.description, this.link, this.creatorId
  });

  int id;
  String title;
  double distance;
  double elevationGain;
  String description;
  String link;
  int creatorId;

  Map<String, String> toMap() {
    Map<String, String> map = <String, String> {
      'title': title,
      'distance': distance.toString(),
      'elevation_gain': elevationGain.toString(),
    };

    if (description != null && description.isNotEmpty) {
      map.addAll({ 'description': description });
    }

    if (link != null && link.length > 0) {
      map.addAll({ 'link': link.toString() });
    }

    return map;
  }

  factory DJKRoute.fromJson(Map json) {
    print("run.fromJson");

    try {
      int id = int.parse(json["id"].toString());
      int creatorId = int.parse(json['creator_id'].toString());
      double distance = double.parse(json['distance'].toString());
      double elevationGain = double.parse(json['elevation_gain'].toString());

      String title = json['title'];
      if (json['title'] == null || json['title'].toString() == "null") {
        title = null;
      } else {
        title = json['title'].toString();
      }

      String description = json['description'];
      if (json['description'] == null || json['description'].toString() == "null") {
        description = null;
      } else {
        description = json['description'].toString();
      }

      String link = json['link'];
      if (json['link'] == null || json['link'].toString() == "null") {
        link = null;
      } else {
        link = json['link'].toString();
      }

      return DJKRoute(
          id, title, distance, elevationGain,
          description, link, creatorId
      );
    } on Exception catch(ex) {
      print(ex.toString());
      return null;
    } on Error catch(err) {
      print(err.toString());
      return null;
    }
  }

  factory DJKRoute.example() {
    return DJKRoute(
      -1,
      "TestRoute",
      23.23,
      234,
      "Beschreibung... Beschrei bung... Beschreibung...Besch reibung...Besch reibung. ..Beschreibung... Beschreibu ng... Beschreibung... ",
      "https://google.com/?s=test",
      1
    );
  }

}