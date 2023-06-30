class BarangModel {
  late final String id_barang;
  late final String nama_barang;
  late final String nama_jenis;
  late final String nama_brand;
  late final String foto;
  late final String id_jenis;
  late final String id_brand;

  BarangModel(
    this.id_barang,
    this.nama_barang,
    this.nama_jenis,
    this.nama_brand,
    this.foto,
    this.id_jenis,
    this.id_brand,
  );

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      json['id_barang'],
      json['nama_barang'],
      json['nama_jenis'],
      json['nama_brand'],
      json['foto'],
      json['id_jenis'],
      json['id_brand'],
    );
  }
}
