import 'package:app_inventori/loading.dart';
import 'package:app_inventori/model/api.dart';
import 'package:app_inventori/model/admin_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:app_inventori/view/admin/tambah_admin.dart';

import 'edit_admin.dart';

class DataAdmin extends StatefulWidget {
  const DataAdmin({Key? key}) : super(key: key);

  @override
  State<DataAdmin> createState() => _DataAdminState();
}

class _DataAdminState extends State<DataAdmin> {
  var loading = false;
  final Logger logger = Logger();
  final List<AdminModel> list = [];
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
    final response = await http.get(Uri.parse(BaseUrl.urlDataAdmin));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final admin = AdminModel.fromJson(api);
        list.add(admin);
      });
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> prosesHapus(String id) async {
    final response = await http.post(Uri.parse(BaseUrl.urlHapusAdmin), body: {
      "id_admin": id,
    });
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        _lihatData();
      });
    } else {
      logger.d(pesan);
      dialogHapus(pesan);
    }
  }

  void dialogHapus(String pesan) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.leftSlide,
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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Data Admin",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahAdmin(_lihatData)),
          );
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
                  final admin = list[i];
                  return Container(
                    margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Card(
                      color: const Color.fromARGB(255, 250, 248, 246),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              admin.nama ?? '',
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EditAdmin(
                                          admin,
                                          _lihatData,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    var id_admin = admin.id_admin;
                                    prosesHapus(id_admin!);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          )
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
