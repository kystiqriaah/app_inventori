import 'dart:convert';

import 'package:app_inventori/Loading.dart';
import 'package:app_inventori/model/Transaksi_masuk_model.dart';
import 'package:app_inventori/view/barang_keluar/detailTbk.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_inventori/model/api.dart';

class DataTransaksiBk extends StatefulWidget {
  const DataTransaksiBk({Key? key}) : super(key: key);

  @override
  State<DataTransaksiBk> createState() => _DataTransaksiBkState();
}

class _DataTransaksiBkState extends State<DataTransaksiBk> {
  bool loading = false;
  String? LvlUsr;
  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.get(Uri.parse(BaseUrl.urlTransaksiBK));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = TransaksiMasukModel(
          id_transaksi: api['id_transaksi'],
          tujuan: api['tujuan'],
          total_item: api['total_item'],
          tgl_transaksi: api['tgl_transaksi'],
          keterangan: api['keterangan'],
        );
        list.add(ab);
        setState(() {
          loading = false;
        });
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _proseshapus(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.urlHapusBK), body: {"id": id});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    if (value == 1) {
      _lihatData();
      setState(() {});
    } else {
      print(pesan);
      dialogHapus(pesan);
    }
  }

  void alertHapus(String id) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      animType: AnimType.topSlide,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      showCloseIcon: true,
      closeIcon: const Icon(Icons.close_fullscreen_outlined),
      title: 'WARNING!!',
      desc:
          'Menghapus data ini akan mengembalikan stok seperti sebelum barang ini diinput. Yakin ingin menghapus?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        _proseshapus(id);
      },
    ).show();
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
    super.initState();
    getPref();
  }

  Future<void> getPref() async {
    await _lihatData();
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      LvlUsr = pref.getString("level");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Transaksi Barang Keluar'),
      ),
      body: RefreshIndicator(
        key: _refresh,
        onRefresh: _lihatData,
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
                            title: Text(x.id_transaksi.toString()),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("+ ${x.total_item.toString()}"),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("(${x.tgl_transaksi.toString()})"),
                              ],
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => DetailTbk(x, _lihatData),
                                      ),
                                    );
                                  },
                                  icon: const FaIcon(
                                    FontAwesomeIcons.eye,
                                    size: 20,
                                  ),
                                ),
                                if (LvlUsr == "1")
                                  IconButton(
                                    onPressed: () {
                                      alertHapus(x.id_transaksi);
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.trash,
                                      size: 20,
                                    ),
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
