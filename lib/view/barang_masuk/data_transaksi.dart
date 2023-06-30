import 'dart:convert';
import 'package:app_inventori/model/Transaksi_masuk_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Loading.dart';
import '../barang_masuk/detail_transaksi.dart';
import 'package:app_inventori/model/api.dart';

class DataTransaksi extends StatefulWidget {
  const DataTransaksi({Key? key}) : super(key: key);

  @override
  State<DataTransaksi> createState() => _DataTransaksiState();
}

class _DataTransaksiState extends State<DataTransaksi> {
  bool isLoading = false;
  String? userLevel;
  final List<TransaksiMasukModel> transaksiList = [];
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  Future<void> _getPref() async {
    setState(() {
      _lihatData();
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    userLevel = pref.getString("level");
  }

  Future<void> _lihatData() async {
    transaksiList.clear();
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.urlTransaksiBM));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final transaksi = TransaksiMasukModel(
          id_transaksi: api['id_transaksi'],
          tujuan: api['tujuan'],
          total_item: api['total_item'],
          tgl_transaksi: api['tgl_transaksi'],
          keterangan: api['keterangan'],
        );
        transaksiList.add(transaksi);
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _prosesHapus(String id) async {
    final response = await http.post(Uri.parse(BaseUrl.urlHapusBM), body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String message = data['message'];
    if (value == 1) {
      setState(() {
        _lihatData();
      });
    } else {
      print(message);
      dialogHapus(message);
    }
  }

  void alertHapus(String id) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.TOPSLIDE,
      headerAnimationLoop: false,
      showCloseIcon: true,
      closeIcon: const Icon(Icons.close_fullscreen_outlined),
      title: 'WARNING!!',
      desc: 'Menghapus data ini akan mengembalikan stok seperti sebelum barang ini di input, Yakin Hapus??',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        _prosesHapus(id);
      },
    ).show();
  }

  void dialogHapus(String message) {
    AwesomeDialog(
      context: context,
      dismissOnTouchOutside: false,
      dialogType: DialogType.ERROR,
      animType: AnimType.RIGHSLIDE,
      headerAnimationLoop: false,
      title: 'ERROR',
      desc: message,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
    ).show();
  }

  @override
  void initState() {
    super.initState();
    _getPref();
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
                "Data Transaksi Barang Masuk",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 41, 69, 91),
      ),
      body: RefreshIndicator(
        key: _refresh,
        onRefresh: _lihatData,
        child: isLoading
            ? const Loading()
            : ListView.builder(
                itemCount: transaksiList.length,
                itemBuilder: (context, index) {
                  final transaksi = transaksiList[index];
                  return Container(
                    margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Card(
                      color: const Color.fromARGB(255, 250, 248, 246),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(transaksi.id_transaksi.toString()),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Item: ${transaksi.total_item.toString()}"),
                                const SizedBox(width: 5),
                                Text("(${transaksi.tgl_transaksi.toString()})"),
                              ],
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DetailTransaksi(
                                          TransaksiMasukModel(
                                            id_transaksi: transaksi.id_transaksi!,
                                            tujuan: transaksi.tujuan!,
                                            total_item: transaksi.total_item!,
                                            tgl_transaksi: transaksi.tgl_transaksi!,
                                            keterangan: transaksi.keterangan!,
                                          ),
                                          () {
                                            setState(() {
                                              _lihatData();
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const FaIcon(FontAwesomeIcons.eye, size: 20),
                                ),
                                if (userLevel == "Admin")
                                  IconButton(
                                    onPressed: () {
                                      alertHapus(transaksi.id_transaksi!);
                                    },
                                    icon: const FaIcon(FontAwesomeIcons.trash, size: 20),
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
    );
  }
}
