import 'package:flutter/material.dart';
import 'package:app_inventori/model/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> list = <String>['Masuk', 'Keluar'];

class TambahTujuan extends StatefulWidget {
  final VoidCallback reload;

  const TambahTujuan(this.reload, {super.key});

  @override
  State<TambahTujuan> createState() => _TambahTujuanState();
}

class _TambahTujuanState extends State<TambahTujuan> {
  FocusNode myFocusNode = new FocusNode();
  String? Tujuan, Tipe;
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      simpan();
    }
  }

  simpan() async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.urlTambahTujuan.toString()),
        body: {"tujuan": Tujuan, "tipe": Tipe},
      );
      final data = jsonDecode(response.body);
      int code = data['success'];
      String pesan = data['message'];
      print(data);
      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          widget.reload();
        });
      } else {
        print(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: const Text(
                "Tambah Jenis Barang",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Jenis";
                }
                return null;
              },
              onSaved: (e) => Tujuan = e,
              decoration: InputDecoration(
                labelText: 'Tujuan Transaksi',
                labelStyle: TextStyle(
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : const Color.fromARGB(255, 32, 54, 70)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 32, 54, 70),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
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
                  value: Tipe,
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      Tipe = value!;
                    });
                  },
                  hint: Text(
                    Tipe ?? "Pilih Tipe Transaksi",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 32, 54, 70),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            MaterialButton(
              onPressed: () {
                check();
              },
              color: const Color.fromARGB(255, 41, 69, 91),
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
