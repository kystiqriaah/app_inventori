class LevelModel {
  String? id_level;
  String? lvl;

  LevelModel({this.id_level, this.lvl});

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id_level: json['id_level'],
      lvl: json['lvl'],
    );
  }
}
