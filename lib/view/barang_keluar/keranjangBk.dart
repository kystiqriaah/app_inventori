import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_inventori/model/KeranjangBm_model.dart';
import 'package:app_inventori/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:app_inventori/view/barang_keluar/TambahBK.dart';
import 'package:app_inventori/view/barang_keluar/Tambahkbk.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class KeranjangBK extends StatefulWidget {
  @override
  State<KeranjangBK> createState() => _KeranjangBKState();
}

class _KeranjangBKState extends State<KeranjangBK> {
  String? IdUsr;
  var loading = false;
  final list = [];

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  Future<void> getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {});
    IdUsr = pref.getString("id");
    _lihatData();
  }

  Future<void> _lihatData() async {
    setState(() {
      loading = true;
    });

    if (IdUsr != null) {
      final response =
          await http.get(Uri.parse(BaseUrl.urlCartBK + IdUsr.toString()));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        data.forEach((api) {
          final ab = new KeranjangBModel(
              api['id_tmp'],
              api['id_barang'],
              api['foto'],
              api['nama_barang'],
              api['nama_brand'],
              api['jumlah']);
          list.add(ab);
        });

        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> _proseshapus(String id) async {
    final response =
        await http.post(Uri.parse(BaseUrl.urlDeleteCBK), body: {"id": id});
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
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 41, 69, 91),
        title: const Text(
          "Keranjang Barang Keluar",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(5),
            width: double.infinity,
            child: MaterialButton(
              color: const Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new Tambahkbk()));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Tambah",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.all(5),
            width: double.infinity,
            child: RefreshIndicator(
              onRefresh: _lihatData,
              key: _refresh,
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final x = list[i];
                        return Container(
                          margin: const EdgeInsets.all(5),
                          child: Card(
                            color: const Color.fromARGB(255, 250, 248, 246),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ID ${x.id_barang}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        x.nama_barang.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        "Brand${x.nama_brand}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        "Jumlah${x.jumlah}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      _proseshapus(x.id_tmp);
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.trash,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.all(5),
            width: double.infinity,
            child: loading
                ? const Text("")
                : MaterialButton(
                    color: const Color.fromARGB(255, 41, 69, 91),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TambahBK(_lihatData),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Proses data",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
