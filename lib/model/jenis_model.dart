class JenisModel {
  String? id_jenis;
  String? nama_jenis;

  JenisModel({this.id_jenis, this.nama_jenis});

  factory JenisModel.fromJson(Map<String, dynamic> json) {
    return JenisModel(
      id_jenis: json['id_jenis'],
      nama_jenis: json['nama_jenis'],
    );
  }
}
