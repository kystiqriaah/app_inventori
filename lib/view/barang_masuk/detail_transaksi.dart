import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_inventori/Loading.dart';
import 'package:app_inventori/model/api.dart';
import 'package:app_inventori/model/barang_masuk_model.dart';
import 'package:app_inventori/model/Transaksi_masuk_model.dart';

class DetailTransaksi extends StatefulWidget {
  final VoidCallback reload;
  final TransaksiMasukModel model;

  DetailTransaksi(this.model, this.reload);

  @override
  State<DetailTransaksi> createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  var loading = false;
  final list = <BarangMasukModel>[];
  Future<void>? _launched;
  late Uri _urlpdf;

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.get(
        Uri.parse(BaseUrl.urlDetailTBM + widget.model.id_transaksi.toString()));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = BarangMasukModel(
          api['foto'],
          api['nama_barang'],
          api['nama_brand'],
          api['jumlah_masuk'],
        );
        list.add(ab);
      });

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await canLaunch(url.toString())) {
      throw "Could not launch $url";
    }
    await launch(
      url.toString(),
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'header_key': 'header_value'},
    );
  }

  @override
  void initState() {
    super.initState();
    getPref();
    _urlpdf = Uri.parse(BaseUrl.urlBaBm + widget.model.id_transaksi.toString());
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
          const SizedBox(height: 20),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _lihatData,
              key: _refresh,
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
                                    const Divider(
                                      color: Colors.transparent,
                                    ),
                                    Text(
                                      "Brand: ${x.nama_brand}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.transparent,
                                    ),
                                    Text(
                                      "Jumlah: ${x.jumlah_masuk}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
          Flexible(
            child: loading == true
                ? const Text("")
                : Column(
                    children: [
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(children: <Widget>[
                            const ListTile(title: Text("Keterangan")),
                            ListTile(
                              title: Text(
                                widget.model.keterangan.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            const ListTile(title: Text("Tujuan Transaksi")),
                            ListTile(
                              title: Text(
                                widget.model.tujuan.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            const ListTile(title: Text("Total Barang Masuk")),
                            ListTile(
                              title: Text(
                                widget.model.total_item.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        color: const Color.fromARGB(255, 41, 69, 91),
                        onPressed: () {
                          _launched = _launchInBrowser(_urlpdf);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Buat BA",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
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
  }
}
