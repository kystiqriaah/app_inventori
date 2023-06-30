import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:app_inventori/model/barang_model.dart';
import 'package:app_inventori/model/api.dart';
import 'package:app_inventori/view/barang_keluar/KeranjangBk.dart';

class Tambahkbk extends StatefulWidget {
  @override
  _TambahkbkState createState() => _TambahkbkState();
}

class _TambahkbkState extends State<Tambahkbk> {
  FocusNode JmFocusNode = new FocusNode();
  String? IdAdm, Barang, Jumlah;

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      IdAdm = pref.getString("id");
    });
  }

  final _key = new GlobalKey<FormState>();
  BarangModel? _currentBR;
  final String? inkBR = BaseUrl.urlDataBr;

  Future<List<BarangModel>> _fetchBR() async {
    var response = await http.get(Uri.parse(inkBR.toString()));
    print('hasil: ' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<BarangModel> listOfBR = items.map<BarangModel>((json) {
        return BarangModel.fromJson(json);
      }).toList();
      return listOfBR;
    } else {
      throw Exception('gagal');
    }
  }

  dialogSukses(String pesan) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Success',
      desc: pesan,
      context: context, // Add context argument here
      btnOkOnPress: () {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new KeranjangBK()));
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dismiss from callback $type');
      },
    ).show();
  }

  dialogGagal(String pesan) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context, // Add context argument here
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

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      Simpan();
    }
  }

  Simpan() async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.urlInputCBK.toString()),
        body: {"barang": Barang!, "jumlah": Jumlah!, "id": IdAdm!},
      );
      final data = jsonDecode(response.body);
      int code = data['success'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          dialogSukses(pesan);
        });
      } else {
        dialogGagal(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
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
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 41, 69, 91),
        title: Text(
          "Tambah Barang Keluar",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            FutureBuilder<List<BarangModel>>(
              future: _fetchBR(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<BarangModel>> snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: const Color.fromARGB(255, 32, 54, 70),
                      width: 0.80,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      items: snapshot.data!
                          .map((listBR) => DropdownMenuItem(
                        value: listBR,
                        child: Text(
                            "${listBR.nama_barang} (${listBR.nama_brand})"),
                      ))
                          .toList(),
                      onChanged: (BarangModel? value) {
                        setState(() {
                          _currentBR = value;
                          Barang = _currentBR!.id_barang.toString();
                        });
                      },
                      isExpanded: true,
                      hint: Text(Barang == null
                          ? "Pilih Barang"
                          : "${_currentBR!.nama_barang} (${_currentBR!.nama_brand})"),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Jumlah";
                }
                return null;
              },
              onSaved: (e) => Jumlah = e,
              focusNode: JmFocusNode,
              decoration: InputDecoration(
                labelText: 'Jumlah Barang',
                labelStyle: TextStyle(
                  color: JmFocusNode.hasFocus
                      ? Colors.blue
                      : const Color.fromARGB(255, 32, 54, 70),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 32, 54, 70),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            MaterialButton(
              color: const Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                check();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
