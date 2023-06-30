import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:app_inventori/model/tanggal_model.dart';
import 'package:app_inventori/model/api.dart';

import '../../model/laporanBm_model.dart';

class LaporanPage extends StatefulWidget {
  final TanggalModel tanggalModel;

  LaporanPage({Key? key, required this.tanggalModel}) : super(key: key);

  @override
  _LaporanPageState createState() =>
      _LaporanPageState(tanggalModel: tanggalModel);
}

class _LaporanPageState extends State<LaporanPage> {
  late TanggalModel tanggalModel;
  late bool loading = false;
  late List<LaporanBmModel> list = [];
  late Future<void>? _launched;
  late Uri _urlpdf;
  late Uri _urlcsv;
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  _LaporanPageState({required this.tanggalModel}) : super() {
    _urlpdf = Uri.parse(BaseUrl.urlBmPdf +
        this.tanggalModel.tgl1.toString() +
        "&&t2=" +
        this.tanggalModel.tgl2.toString());
    _urlcsv = Uri.parse(BaseUrl.urlBmCsv +
        this.tanggalModel.tgl1.toString() +
        "&&t2=" +
        this.tanggalModel.tgl2.toString());
  }

  void getPref() async {
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {});
    loading = true;
    final response = await http.get(Uri.parse(BaseUrl.urlLaporanBm +
        this.tanggalModel.tgl1.toString() +
        "&&tgl2=" +
        this.tanggalModel.tgl2.toString()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = LaporanBmModel(
          api['id_barang_masuk'],
          api['id_barang'],
          api['nama_barang'],
          api['nama_brand'],
          api['jumlah_masuk'],
          api['tgl_transaksi'],
          api['keterangan'],
          api['nama'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
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
              _launched = _launchInBrowser(_urlpdf);
            }),
            child: const FaIcon(FontAwesomeIcons.filePdf),
            backgroundColor: const Color.fromARGB(255, 204, 0, 0),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () => setState(() {
              _launched = _launchInBrowser(_urlcsv);
            }),
            child: FaIcon(FontAwesomeIcons.fileCsv),
            backgroundColor: const Color.fromARGB(255, 0, 128, 0),
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
                              TableRow(
                                children: <Widget>[
                                  const ListTile(
                                    title: Text("Kode Barang Masuk"),
                                  ),
                                  ListTile(
                                    title: Text(
                                      x.id_barang_masuk.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const ListTile(
                                    title: Text("Kode Barang"),
                                  ),
                                  ListTile(
                                    title: Text(
                                      x.id_barang.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const ListTile(
                                    title: Text("Nama Barang"),
                                  ),
                                  ListTile(
                                    title: Text(
                                      x.nama_barang.toString() +
                                          "(" +
                                          x.nama_brand.toString() +
                                          ")",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const ListTile(
                                    title: Text("Jumlah Masuk"),
                                  ),
                                  ListTile(
                                    title: Text(
                                      x.jumlah_masuk.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const ListTile(
                                    title: Text("Tgl Masuk"),
                                  ),
                                  ListTile(
                                    title: Text(
                                      x.tgl_transaksi.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const ListTile(
                                    title: Text("Keterangan"),
                                  ),
                                  ListTile(
                                    title: Text(
                                      x.keterangan.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  const ListTile(
                                    title: Text("User Input"),
                                  ),
                                  ListTile(
                                    title: Text(
                                      x.nama.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
    properties.add(DiagnosticsProperty<Future<void>?>('_launched', _launched));
  }
}
