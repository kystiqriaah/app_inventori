import 'package:app_inventori/view/tujuan/tambah_tujuan.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:app_inventori/Loading.dart';
import 'package:app_inventori/model/tujuan_model.dart';
import 'package:app_inventori/model/api.dart';

import 'edit_tujuan.dart';

class DataTujuan extends StatefulWidget {
  const DataTujuan({super.key});

  @override
  State<DataTujuan> createState() => _DataTujuanState();
}

class _DataTujuanState extends State<DataTujuan> {
  var loading = false;
  final List<TujuanModel> list = [];

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

    final response = await http.get(Uri.parse(BaseUrl.urlDataT));
    if (response.contentLength == 2) {
      // Menangani kasus ketika respon kosong.
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = TujuanModel(api['id_tujuan'], api['tujuan'], api['tipe']);
        list.add(ab);
        setState(() {
          loading = false;
        });
      });
    }
  }

  Future<void> _proseshapus(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.urlHapusTujuan), body: {"id_tujuan": id});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        _lihatData();
      });
    } else {
      print(pesan);
      dialogHapus(pesan);
    }
  }

  void dialogHapus(String pesan) {
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
              child: const Text(
                "Data Tujuan",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
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
                            title: Text(
                              x.tujuan.toString(),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Tombol Edit ditekan
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => 
                                        EditTujuan(x, _lihatData() as VoidCallback))
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _proseshapus(x.id_tujuan);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tombol Tambah ditekan
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new TambahTujuan(_lihatData)));
        },
        backgroundColor: const Color.fromARGB(255, 41, 69, 91),
        child: const Icon(Icons.add),
      ),
    );
  }
}
