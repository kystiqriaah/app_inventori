class TujuanModel {
  String id_tujuan;
  String tujuan;
  String tipe;

  TujuanModel(this.id_tujuan, this.tujuan, this.tipe);

  factory TujuanModel.fromJson(Map<String, dynamic> json) {
    return TujuanModel(
      json['id_tujuan'],
      json['tujuan'],
      json['tipe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_tujuan': id_tujuan,
      'tujuan': tujuan,
      'tipe': tipe,
    };
  }
}
