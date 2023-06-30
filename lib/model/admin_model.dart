class AdminModel {
  String? id_admin;
  String? nama;
  String? username;
  String? password;
  String? level;

  AdminModel(this.id_admin, this.nama, this.username, this.password, this.level);

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      json['id_admin'],
      json['nama'],
      json['username'],
      json['password'],
      json['lvl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_admin': id_admin,
      'nama': nama,
      'username': username,
      'password': password,
      'lvl': level,
    };
  }
}
