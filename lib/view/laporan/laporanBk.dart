import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_inventori/model/tanggal_model.dart';
import 'package:app_inventori/model/LaporanBk_model.dart';
import 'package:app_inventori/model/api.dart';
import 'package:url_launcher/url_launcher.dart';

class LaporanBk extends StatefulWidget {
  final TanggalModel tanggalModel;

  LaporanBk({Key? key, required this.tanggalModel}) : super(key: key);

  @override
  State<LaporanBk> createState() => _LaporanBkState(tanggalModel: tanggalModel);
}

class _LaporanBkState extends State<LaporanBk> {
  late TanggalModel tanggalModel;
  _LaporanBkState({required this.tanggalModel}) : super();
  var loading = false;
  final list = [];
  Future<void>? _Launched;
  late Uri _urlpdf = Uri.parse(BaseUrl.urlBkPdf +
      this.tanggalModel.tgl1.toString() +
      "&&t2=" +
      this.tanggalModel.tgl2.toString());

  late Uri _urlcsv = Uri.parse(BaseUrl.urlBkCsv +
      this.tanggalModel.tgl1.toString() +
      "&&t2=" +
      this.tanggalModel.tgl2.toString());

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {});
    loading = true;
    final response = await http.get(Uri.parse(BaseUrl.urlLaporanBk +
        this.tanggalModel.tgl1.toString() +
        "&&tgl2=" +
        this.tanggalModel.tgl2.toString()));

    if (response.contentLength == 2) {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = LaporanBkModel(
          id_barang_keluar: api['id_barang_keluar'],
          id_barang: api['id_barang'],
          nama_barang: api['nama_barang'],
          nama_brand: api['nama_brand'],
          jumlah_keluar: api['jumlah_keluar'],
          tgl_transaksi: api['tgl_transaksi'],
          keterangan: api['keterangan'],
          nama: api['nama'],
        );

        list.add(ab);
        setState(() {
          loading = false;
        });
      });
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Periode ${tanggalModel.tgl1.toString().substring(0, 10)} s/d ${tanggalModel.tgl2.toString().substring(0, 10)}",
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => setState(() {
              _launchInBrowser(_urlcsv);
            }),
            backgroundColor: const Color.fromARGB(255, 0, 128, 0),
            child: const FaIcon(FontAwesomeIcons.fileCsv),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () => setState(() {
              _launchInBrowser(_urlpdf);
            }),
            backgroundColor: const Color.fromARGB(255, 204, 0, 0),
            child: const FaIcon(FontAwesomeIcons.filePdf),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? const Center(
                child: Text("Data Kosong"),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
                    margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Card(
                      color: const Color.fromARGB(255, 250, 248, 246),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(children: <Widget>[
                                const ListTile(
                                    title: Text("Kode Barang Keluar")),
                                ListTile(
                                  title: Text(
                                    x.id_barang_keluar.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ]),
                              TableRow(children: <Widget>[
                                const ListTile(title: Text("Kode Barang")),
                                ListTile(
                                  title: Text(
                                    x.id_barang.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ]),
                              TableRow(children: <Widget>[
                                const ListTile(title: Text("Nama Barang")),
                                ListTile(
                                  title: Text(
                                    x.nama_barang.toString() +
                                        "(" +
                                        x.nama_brand.toString() +
                                        ")",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ]),
                              TableRow(children: <Widget>[
                                const ListTile(title: Text("Jumlah Keluar")),
                                ListTile(
                                  title: Text(
                                    x.jumlah_keluar.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ]),
                              TableRow(children: <Widget>[
                                const ListTile(title: Text("Tgl Keluar")),
                                ListTile(
                                  title: Text(
                                    x.tgl_transaksi.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ]),
                              TableRow(children: <Widget>[
                                const ListTile(title: Text("Keterangan")),
                                ListTile(
                                  title: Text(
                                    x.keterangan.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ]),
                              TableRow(children: <Widget>[
                                const ListTile(title: Text("User Input")),
                                ListTile(
                                  title: Text(
                                    x.nama.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Future<void>?>('_Launched', _Launched));
  }
}
