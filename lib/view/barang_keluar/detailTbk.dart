import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:app_inventori/model/api.dart';
import 'package:app_inventori/model/barang_keluar_model.dart';
import 'package:app_inventori/model/transaksi_masuk_model.dart';
import 'package:app_inventori/Loading.dart';

class DetailTbk extends StatefulWidget {
  final VoidCallback reload;
  final TransaksiMasukModel model;

  DetailTbk(this.model, this.reload);

  @override
  _DetailTbkState createState() => _DetailTbkState();
}

class _DetailTbkState extends State<DetailTbk> {
  var loading = false;
  Future<void>? _launched;
  late Uri _urlpdf = Uri.parse(BaseUrl.urlBaBk + widget.model.id_transaksi.toString());

  final list = [];

  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refresh2 = GlobalKey<RefreshIndicatorState>();

  Future<void> getPref() async {
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.get(Uri.parse(BaseUrl.urlDetailTBK + widget.model.id_transaksi.toString()));

    if (response.contentLength == 2) {
      final data = jsonDecode(response.body);

      data.forEach((api) {
        final ab = BarangKeluarModel(
          api['foto'],
          api['nama_barang'],
          api['nama_brand'],
          api['jumlah_keluar'],
        );
        list.add(ab);

        setState(() {
          loading = false;
        });
      });
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await canLaunch(url.toString())) {
      throw 'Could not launch $url';
    }

    await launch(url.toString(), forceSafariVC: false, forceWebView: false);
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
                "Transaksi #${widget.model.id_transaksi}",
                style: const TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: RefreshIndicator(
              key: _refresh,
              onRefresh: _lihatData,
              child: loading
                  ? const Loading()
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final x = list[i];
                        return Container(
                          margin: const EdgeInsets.all(5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 64,
                                    minHeight: 64,
                                    maxWidth: 84,
                                    maxHeight: 84,
                                  ),
                                  child: Image.network(
                                    BaseUrl.imagePath + x.foto.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      x.nama_barang.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      "Brand ${x.nama_brand}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      "Jumlah ${x.jumlah_keluar}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
          Flexible(
            child: loading
                ? const Text("")
                : Column(
                    children: [
                      Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(
                            children: <Widget>[
                              const ListTile(
                                title: Text("Keterangan"),
                              ),
                              ListTile(
                                title: Text(
                                  widget.model.keterangan.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              const ListTile(
                                title: Text("Tujuan Transaksi"),
                              ),
                              ListTile(
                                title: Text(
                                  widget.model.tujuan.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              const ListTile(
                                title: Text("Total Barang Masuk"),
                              ),
                              ListTile(
                                title: Text(
                                  widget.model.total_item.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      MaterialButton(
                        color: const Color.fromARGB(255, 41, 69, 91),
                        onPressed: () {
                          _launchInBrowser(_urlpdf);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Buat BA",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Future<void>?>('_launched', _launched));
    properties.add(DiagnosticsProperty<GlobalKey<RefreshIndicatorState>>('_refresh2', _refresh2));
  }
}