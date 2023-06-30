import 'package:flutter/material.dart';
import 'package:app_inventori/model/tujuan_model.dart';
import 'package:app_inventori/model/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'data_tujuan.dart';

const List<String> list = <String>['Masuk', 'Keluar'];

class EditTujuan extends StatefulWidget {
  final VoidCallback reload;
  final TujuanModel model;

  const EditTujuan(this.model, this.reload, {super.key});

  @override
  State<EditTujuan> createState() => _EditTujuanState();
}

class _EditTujuanState extends State<EditTujuan> {
  FocusNode myFocusNode = FocusNode();
  String? id_tujuan, Tujuan, Tipe, T7an;
  final _key = GlobalKey<FormState>();
  TextEditingController? txtTujuan;

  setup() async {
    T7an = widget.model.tipe;

    if (T7an == "M") {
      T7an = "Masuk";
    } else if (T7an == "K") {
      T7an = "Keluar";
    }

    txtTujuan = TextEditingController(text: widget.model.tujuan);
    id_tujuan = widget.model.id_tujuan;
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      UpdateTujuan();
    }
  }

  Future<void> UpdateTujuan() async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.urlEditTujuan),
        body: {
          "id_tujuan": id_tujuan,
          "tujuan": Tujuan,
          "tipe": Tipe,
        },
      );

      final data = jsonDecode(response.body);
      int code = data['success'];
      String pesan = data['message'];

      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DataTujuan()),
          );
        });
      } else {
        print(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Tujuan Transaksi",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: txtTujuan,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Tujuan";
                }
                return null;
              },
              onSaved: (e) => Tujuan = e!,
              decoration: InputDecoration(
                labelText: 'Tujuan Transaksi',
                labelStyle: TextStyle(
                  color: myFocusNode.hasFocus
                      ? Colors.blue
                      : const Color.fromARGB(255, 32, 54, 70),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 32, 54, 70),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  style: BorderStyle.solid,
                  color: const Color.fromARGB(255, 32, 54, 70),
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
                  isExpanded: true,
                  hint: Text(
                    Tipe == null ? T7an.toString() : Tipe.toString(),
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
                "Edit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
