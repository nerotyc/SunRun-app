
class Group {

  Group(
      this.id, this.name, this.description, this.score,
      this.run_count, this.num_participants, this.sum_duration,
      this.sum_distance_walk, this.sum_distance_run, this.sum_distance_bike,
      this.sum_distance_ebike, this.creator_id
      );

  Group.createNew({
    this.id, this.name, this.description, this.score,
    this.run_count, this.num_participants, this.sum_duration,
    this.sum_distance_walk, this.sum_distance_run, this.sum_distance_bike,
    this.sum_distance_ebike, this.creator_id
  });

  int? id;
  int? creator_id;
  String? name;
  String? description;
  double? score;
  int? run_count;
  int? num_participants;
  Duration? sum_duration;
  double? sum_distance_walk;
  double? sum_distance_run;
  double? sum_distance_bike;
  double? sum_distance_ebike;

  String get sumDurationFormatted {
    List<String> hms = sum_duration.toString().split(".").first.split(":");
    return hms[0] + "h " + hms[1] + "min " + hms[0] + "s";
  }

  factory Group.fromJson(Map json) {
    try {
      int id = int.parse(json["id"].toString());
      int creatorId = int.parse(json['creator_id'].toString());
      String? name = json['name'];
      String? description = json['description'];

      double score = double.parse(json['score'].toString());
      int run_count = int.parse(json['run_count'].toString());
      int num_participants = int.parse(json['num_participants'].toString());
      double _hours = double.parse(json['sum_duration'].toString());
      int seconds = (_hours * 3600).toInt();

      double sum_distance_walk = double.parse(json['sum_distance_walk'].toString());
      double sum_distance_run = double.parse(json['sum_distance_run'].toString());
      double sum_distance_bike = double.parse(json['sum_distance_bike'].toString());
      double sum_distance_ebike = double.parse(json['sum_distance_ebike'].toString());

      return Group(
          id,
          name,
          description,
          score,
          run_count,
          num_participants,
          Duration(seconds: seconds),
          sum_distance_walk,
          sum_distance_run,
          sum_distance_bike,
          sum_distance_ebike,
          creatorId
      );
    } on Exception catch(ex) {
      print(ex.toString());
      throw ex;
    } on Error catch(err) {
      print(err.toString());
      throw err;
    }
  }

  Map<String, String?> toMap() {
    Map<String, String?> map = <String, String?> {
      'name': this.name,
    };

    if (description != null && description!.isNotEmpty) {
      map.addAll({ 'description': description });
    }

    return map;
  }

  factory Group.example() {
    return Group(
        -1,
        "name..",
        "descr. descr... descr... descr... descr...d escr. . descr... de scr.....",
      20.02,
      2,
      12,
      Duration(minutes: 32),
      1, 2,3,4,
      1
    );
  }

}