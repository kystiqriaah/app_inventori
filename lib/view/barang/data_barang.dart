import 'package:app_inventori/view/barang/detail_barang.dart';
import 'package:app_inventori/view/barang/edit_barang.dart';
import 'package:app_inventori/view/barang/tambah_barang.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:app_inventori/loading.dart';
import 'dart:convert';
import 'package:app_inventori/model/barang_model.dart';
import 'package:app_inventori/model/api.dart' as Api;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class DataBarang extends StatefulWidget {
  @override
  State<DataBarang> createState() => _DataBarangState();
}

class _DataBarangState extends State<DataBarang> {
  var loading = false;
  final list = [];
  String? LvlUsr;

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      LvlUsr = pref.getString("level");
    });
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.get(Uri.parse(Api.BaseUrl.urlDataBarang));

    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new BarangModel(
            api['id_barang'],
            api['nama_barang'],
            api['nama_jenis'],
            api['nama_brand'],
            api['foto'],
            api['id_jenis'],
            api['id_brand']);
        list.add(ab);
      });

      setState(() {
        loading = false;
      });
    }
  }

  _proseshapus(String id) async {
    final response = await http
        .post(Uri.parse(Api.BaseUrl.urlHapusBarang), body: {"id_barang": id});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];

    if (value == 1) {
      setState(() {
        _lihatData();
      });
    } else {
      logger.e(pesan); // Log an error message
      dialogHapus(pesan);
    }
  }

  dialogHapus(String pesan) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      headerAnimationLoop: false,
      title: 'ERROR',
      desc: pesan,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
    ).show();
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
                "Data Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print("tambah jenis");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new TambahBarang(_lihatData)));
        },
        backgroundColor: const Color.fromARGB(255, 41, 69, 91),
        child: const Icon(Icons.add),
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
                          ListTile(
                            leading: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 44,
                                minHeight: 44,
                                maxWidth: 64,
                                maxHeight: 64,
                              ),
                              child: Image.network(
                                Api.BaseUrl.imagePath + x.foto.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              x.nama_barang.toString(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  // detail
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          DetailBarang(x, _lihatData)));
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.eye,
                                  color: Colors.grey,
                                ),
                                iconSize: 20,
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  // edit
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          EditBarang(x, _lihatData)));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (LvlUsr == "1")
                                IconButton(
                                  onPressed: () {
                                    // delete
                                    _proseshapus(x.id_barang);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.grey,
                                  ),
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
}
