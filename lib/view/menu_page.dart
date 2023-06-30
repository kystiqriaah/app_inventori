import 'dart:convert';

import 'package:app_inventori/view/barang/data_barang.dart';
import 'package:app_inventori/view/barang_masuk/data_transaksi.dart';
import 'package:app_inventori/view/laporan/formLbk.dart';
import 'package:app_inventori/view/laporan/form_laporan.dart';
import 'package:app_inventori/view/stok/data_stok.dart';
import 'package:app_inventori/view/tujuan/data_tujuan.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_inventori/model/api.dart';
import 'package:app_inventori/view/admin/data_admin.dart';
import 'package:app_inventori/view/jenis/data_jenis.dart';
import '../model/count_data.dart';
import 'barang_keluar/data_transaksiBk.dart';

class MenuPage extends StatefulWidget {
  final VoidCallback logout;

  const MenuPage(this.logout, {Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();

  void logOut() {}
}

class _MenuPageState extends State<MenuPage> {
  FocusNode myFocusNode = FocusNode();
  String? idUsr, lvlUsr, namaUsr;
  bool _mdTileExpanded = false;
  bool _lpTileExpanded = false;
  bool _tsTileExpanded = false;

  void getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idUsr = pref.getString("id");
    });
    namaUsr = pref.getString("nama");
    lvlUsr = pref.getString("level");
  }

  logOut() {
    setState(() {
      widget.logOut();
    });
  }

  var loading = false;
  String Stl = "0";
  String Sbm = "0";
  String Sbk = "0";
  final ex = List<CountData>.empty(growable: true);

   Future<void> countBR() async {
    setState(() {
      loading = true;
    });
    ex.clear();
    final response = await http.get(Uri.parse(BaseUrl.urlCount));
    final data = jsonDecode(response.body);

    data.forEach((apt) {
      final exp = CountData(BaseUrl.urlCount, apt['jm'], BaseUrl.urlCount);
      ex.add(exp);
      setState(() {
        Stl = exp.stok.toString();
        Sbm = exp.jm.toString();
        Sbk = exp.jk.toString();
      });
    });

    setState(() {
      countBR();
      loading = false;
    });
  }

  void infoOut() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      headerAnimationLoop: true,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Ready to Leave?',
      desc:
          'Select "Logout" below if you are ready to end your current session.',
      reverseBtnOrder: true,
      btnCancelOnPress: () {},
      btnOkText: 'Logout',
      btnOkOnPress: () {
        logOut();
      },
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
        elevation: 0.1,
        backgroundColor: const Color.fromARGB(255, 41, 69, 91),
        title: const Text('INVENTORI'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Card(
              color: const Color.fromARGB(255, 250, 248, 246),
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Color.fromARGB(255, 160, 238, 286),
                        width: 5,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: const Text(
                          "Total Barang Masuk",
                          style:
                              TextStyle(color: Color.fromARGB(255, 23, 33, 41)),
                        ),
                        subtitle: Sbm == "null"
                            ? const Text(
                                "0",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                Sbm,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        trailing: const Icon(
                          FontAwesomeIcons.box,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Card(
              color: const Color.fromARGB(255, 250, 248, 246),
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Color.fromARGB(255, 160, 238, 286),
                        width: 5,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: const Text(
                          "Total Barang Keluar",
                          style:
                              TextStyle(color: Color.fromARGB(255, 23, 33, 41)),
                        ),
                        subtitle: Sbm == "null"
                            ? const Text(
                                "0",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                Sbm,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        trailing: const Icon(
                          FontAwesomeIcons.box,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Card(
              color: const Color.fromARGB(255, 250, 248, 246),
              child: ClipPath(
                clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Color.fromARGB(255, 160, 238, 286),
                        width: 5,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: const Text(
                          "Total Stock Barang",
                          style:
                              TextStyle(color: Color.fromARGB(255, 23, 33, 41)),
                        ),
                        subtitle: Sbm == "null"
                            ? const Text(
                                "0",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                Sbm,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 23, 33, 41),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        trailing: const Icon(
                          FontAwesomeIcons.box,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: GestureDetector(
        onHorizontalDragStart: (_) {}, // Disable drag gesture
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(namaUsr.toString()),
                accountEmail: lvlUsr.toString() == "1"
                    ? const Text("Super Admin")
                    : const Text("Admin"),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage("assets/itg.png"),
                  backgroundColor: Color.fromARGB(255, 41, 69, 91),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profil"),
                onTap: () {},
              ),
              const Divider(height: 25, thickness: 1),
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: const FaIcon(FontAwesomeIcons.database),
                  title: Text(
                    "Master Data",
                    style: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : const Color.fromARGB(255, 51, 53, 54),
                    ),
                  ),
                  trailing: FaIcon(
                    _mdTileExpanded
                        ? FontAwesomeIcons.chevronDown
                        : FontAwesomeIcons.chevronRight,
                    size: 15,
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : const Color.fromARGB(255, 119, 120, 121),
                  ),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      _mdTileExpanded = expanded;
                    });
                  },
                  children: [
                    ListTile(
                      leading: const Text(""),
                      title: const Text("Data Jenis"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new DataJenis(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Text(""),
                      title: const Text("Data Brand"),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Text(""),
                      title: const Text("Data Barang"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => new DataBarang(),
                            ),
                          );
                      },
                    ),
                    ListTile(
                      leading: const Text(""),
                      title: const Text("Data Tujuan"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => new DataTujuan(),
                            ),
                          );
                      },
                    ),
                    if (lvlUsr == "1") ...[
                      ListTile(
                        leading: const Text(""),
                        title: const Text("Data Admin"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => new DataAdmin(),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const Divider(height: 25, thickness: 1),
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: const FaIcon(FontAwesomeIcons.exchange),
                  title: Text(
                    "Transaksi",
                    style: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : const Color.fromARGB(255, 51, 53, 54),
                    ),
                  ),
                  trailing: FaIcon(
                    _tsTileExpanded
                        ? FontAwesomeIcons.chevronDown
                        : FontAwesomeIcons.chevronRight,
                    size: 15,
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : const Color.fromARGB(255, 119, 120, 121),
                  ),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      _tsTileExpanded = expanded;
                    });
                  },
                  children: [
                    ListTile(
                      leading: const Text(""),
                      title: const Text("Barang Masuk"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => new DataTransaksi())
                        );
                      },
                    ),
                    ListTile(
                      leading: const Text(""),
                      title: const Text("Barang Keluar"),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => new DataTransaksiBk()));
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 25, thickness: 1),
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: const FaIcon(FontAwesomeIcons.clipboardList),
                  title: Text(
                    "Laporan",
                    style: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : const Color.fromARGB(255, 51, 53, 54),
                    ),
                  ),
                  trailing: FaIcon(
                    _lpTileExpanded
                        ? FontAwesomeIcons.chevronDown
                        : FontAwesomeIcons.chevronRight,
                    size: 15,
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : const Color.fromARGB(255, 119, 120, 121),
                  ),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      _lpTileExpanded = expanded;
                    });
                  },
                  children: [
                    ListTile(
                      leading: const Text(""),
                      title: const Text("Data Stok"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => new DataStok())
                        );
                      },
                    ),
                    ListTile(
                      leading: const Text(""),
                      title: const Text("Laporan Barang Masuk"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => new FormLaporan())
                        );
                      },
                    ),
                    ListTile(
                      leading: const Text(""),
                      title: const Text("Laporan Barang Keluar"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => new FormLbk())
                        );
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () => infoOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
