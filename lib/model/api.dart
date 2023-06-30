class BaseUrl {
  static const String baseUrl = "http://192.168.1.105/flutter_inven/api";
  static const String imagePath = "http://192.168.1.105/flutter_inven/images";

  // Data jenis
  static const String urlDataJenis = "$baseUrl/jenis/data_jenis.php";
  static const String urlTambahJenis = "$baseUrl/jenis/tambah_jenis.php";
  static const String urlEditJenis = "$baseUrl/jenis/edit_jenis.php";
  static const String urlHapusJenis = "$baseUrl/jenis/delete_jenis.php";
  // End data jenis

  // Data admin
  static const String urlDataAdmin = "$baseUrl/admin/data_admin.php";
  static const String urlTambahAdmin = "$baseUrl/admin/tambah_admin.php";
  static const String urlEditAdmin = "$baseUrl/admin/edit_admin.php";
  static const String urlHapusAdmin = "$baseUrl/admin/delete_admin.php";
  // End Data admin

  // Level
  static const String urlDataLevel = "$baseUrl/level/data_level.php";
  // End Level

  // Login
  static const String urlLogin = "$baseUrl/auth/login.php";
  // End Login

  // statistik
  static const String urlCount = "$baseUrl/statistik/count.php";

  // Data barang
  static const String urlDataBarang = "$baseUrl/barang/data_barang.php";
  static const String urlTambahBarang = "$baseUrl/barang/tambah_barang.php";
  static const String urlEditBarang = "$baseUrl/barang/edit_barang.php";
  static const String urlHapusBarang = "$baseUrl/barang/delete_barang.php";
  // End Data barang

  // Data Brand
  static const String urlDataBrand = "$baseUrl/brand/data_brand.php";

  // Data Brand
  static const String urlDataT = "$baseUrl/brand/data_tujuan.php";
  static const String urlDataTBM = "$baseUrl/brand/tujuan_bm.php";
  static const String urlDataTBK = "$baseUrl/brand/tujuan_bk.php";
  static const String urlTambahTujuan = "$baseUrl/brand/input_tujuan.php";
  static const String urlEditTujuan = "$baseUrl/brand/update_tujuan.php";
  static const String urlHapusTujuan = "$baseUrl/brand/delete_tujuan.php";

  // Transaksi Masuk
  static const String urlTransaksiBM= "$baseUrl/barang_masuk/transaksi_bm.php";
  static const String urlHapusBM = "$baseUrl/barang_masuk/delete_bm.php";
  static const String urlBaBm = "$baseUrl/barang_masuk/ba_bm.php?i=";
  static const String urlDetailTBM = "$baseUrl/barang_masuk/data_barang_masuk.php?id=";
  static const String urlCartBM = "$baseUrl/barang_masuk/cart_bm.php?id=";
  static const String urlDeleteCBM= "$baseUrl/barang_masuk/delete_cartbm.php";
  static const String urlInputCBM= "$baseUrl/barang_masuk/input_cartbm.php";
  static const String urlTambahBM= "$baseUrl/barang_masuk/input_bm.php";

  // Transaksi Keluar
  static const String urlTransaksiBK= "$baseUrl/barang_keluar/transaksi_bk.php";
  static const String urlHapusBK = "$baseUrl/barang_keluar/delete_bk.php";
  static const String urlBaBk = "$baseUrl/barang_keluar/ba_bk.php?i=";
  static const String urlDetailTBK = "$baseUrl/barang_keluar/data_barang_keluar.php?id=";
  static const String urlCartBK = "$baseUrl/barang_keluar/cart_bk.php?id=";
  static const String urlDeleteCBK= "$baseUrl/barang_keluar/delete_cartbk.php";
  static const String urlInputCBK= "$baseUrl/barang_keluar/input_cartbk.php";
  static const String urlTambahBk= "$baseUrl/barang_keluar/input_bk.php"; 
  static const String urlDataBr= "$baseUrl/barang_keluar/data_br.php";  
  
  // Laporan
  static const String urlLaporanBm= "$baseUrl/laporan/laporan_bm.php?tgl1=";
  static const String urlBmPdf= "$baseUrl/laporan/report_bm.php?t1="; 
  static const String urlBmCsv= "$baseUrl/laporan/bm_csv.php?t1=";
  static const String urlLaporanBk= "$baseUrl/laporan/laporan_bk.php?tgl1=";
  static const String urlBkPdf= "$baseUrl/laporan/report_bk.php?t1="; 
  static const String urlBkCsv= "$baseUrl/laporan/bk_csv.php?t1=";
  static const String urlDataStok= "$baseUrl/stok/data_stok.php";
  static const String urlStokPdf= "$baseUrl/laporan/report_stok.php"; 
  static const String urlStokCsv= "$baseUrl/stok/stokcsv.php";
}
