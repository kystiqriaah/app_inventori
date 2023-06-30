import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:app_inventori/Loading.dart';
import 'dart:convert';
import 'package:app_inventori/model/stok_model.dart';
import 'package:app_inventori/model/api.dart';
import 'package:url_launcher/url_launcher.dart';

class DataStok extends StatefulWidget {
  @override
  State<DataStok> createState() => _DataStokState();
}

class _DataStokState extends State<DataStok> {
  Future<void>? _Launched;
  var loading = false;
  final list = [];

  final Uri _urlpdf = Uri.parse(BaseUrl.urlStokPdf);
  final Uri _urlcsv = Uri.parse(BaseUrl.urlStokCsv);
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {});
    loading = true;
    final response = await http.get(Uri.parse(BaseUrl.urlDataStok));

    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = StokModel(
          api['no'],
          api['id_barang'],
          api['nama_barang'],
          api['nama_jenis'],
          api['nama_brand'],
          api['stok'],
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
    super.initState();
    getPref();
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
              child: const Text(
                "Data Stok Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
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
              _Launched = _launchInBrowser(_urlpdf);
            }),
            child: FaIcon(FontAwesomeIcons.filePdf),
            backgroundColor: const Color.fromARGB(255, 204, 0, 0),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () => setState(() {
              _Launched = _launchInBrowser(_urlcsv);
            }),
            child: FaIcon(FontAwesomeIcons.file),
            backgroundColor: const Color.fromARGB(255, 0, 128, 0),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? const Loading()
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
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(children: <Widget>[
                                const ListTile(title: Text("Kode Barang")),
                                ListTile(
                                  title: Text(
                                    x.id_barang.toString(),
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ]),
                              TableRow(children: <Widget>[
                                const ListTile(title: Text("Nama Barang")),
                                ListTile(
                                  title: Text(
                                    x.nama_barang.toString() + "(" + x.nama_brand.toString() + ")",
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ]),
                              TableRow(children: <Widget>[
                                const ListTile(title: Text("Stok")),
                                ListTile(
                                  title: Text(
                                    x.stok.toString(),
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
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
