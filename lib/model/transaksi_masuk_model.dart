class TransaksiMasukModel {
  String? id_transaksi;
  String? tujuan;
  int? total_item;
  String? tgl_transaksi;
  String? keterangan;

  TransaksiMasukModel({
    required this.id_transaksi,
    required this.tujuan,
    required this.total_item,
    required this.tgl_transaksi,
    required this.keterangan,
  });

  TransaksiMasukModel.fromJson(Map<String, dynamic> json)
      : id_transaksi = json['id_transaksi'],
        tujuan = json['tujuan'],
        total_item = json['total_item'],
        tgl_transaksi = json['tgl_transaksi'],
        keterangan = json['keterangan'];
}
