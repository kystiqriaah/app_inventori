class LaporanBkModel {
  int id_barang_keluar;
  int id_barang;
  String nama_barang;
  String nama_brand;
  int jumlah_keluar;
  String tgl_transaksi;
  String keterangan;
  String nama;

  LaporanBkModel({
    required this.id_barang_keluar,
    required this.id_barang,
    required this.nama_barang,
    required this.nama_brand,
    required this.jumlah_keluar,
    required this.tgl_transaksi,
    required this.keterangan,
    required this.nama,
  });

  factory LaporanBkModel.fromJson(Map<String, dynamic> json) {
    return LaporanBkModel(
      id_barang_keluar: json['id_barang_keluar'],
      id_barang: json['id_barang'],
      nama_barang: json['nama_barang'],
      nama_brand: json['nama_brand'],
      jumlah_keluar: json['jumlah_keluar'],
      tgl_transaksi: json['tgl_transaksi'],
      keterangan: json['keterangan'],
      nama: json['nama'],
    );
  }
}
