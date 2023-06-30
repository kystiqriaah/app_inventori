// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'dart:convert' show jsonDecode;
import 'package:app_inventori/model/jenis_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../model/api.dart';

class EditJenis extends StatefulWidget {
  final VoidCallback reload;
  final JenisModel model;
  const EditJenis(this.model, this.reload, {super.key});

  @override
  State<EditJenis> createState() => _EditJenisState();
}

class _EditJenisState extends State<EditJenis> {
  // ignore: unnecessary_new
  FocusNode myFocusNode = new FocusNode();
  // ignore: non_constant_identifier_names
  String? id_jenis, jenis;
  // ignore: unnecessary_new
  final _key = new GlobalKey<FormState>();
  TextEditingController? txtidJenis, txtJenis;

  get http => null;
  setup() async {
    txtJenis = TextEditingController(text: widget.model.nama_jenis);
    id_jenis = widget.model.id_jenis;
  }

  // ignore: non_constant_identifier_names
  Check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      ProsUp();
    }
  }

  // ignore: non_constant_identifier_names
  ProsUp() async {
    try {
      final respon = await http.post(Uri.parse(BaseUrl.urlEditJenis.toString()),
          body: {"id_jenis": id_jenis, "jenis": jenis});
      final data = jsonDecode(respon.body);
      if (kDebugMode) {
        print(data);
      }
      int code = data['success'];
      String pesan = data['message'];
      if (kDebugMode) {
        print(data);
      }
      if (code == 1) {
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        if (kDebugMode) {
          print(pesan);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 41, 69, 91),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Edit Jenis Barang",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            )
          ],
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: txtJenis,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi jenis";
                } else {
                  return null;
                }
              },
              onSaved: (e) => jenis = e,
              decoration: InputDecoration(
                labelText: 'Jenis Barang',
                labelStyle: TextStyle(
                    color: myFocusNode.hasFocus
                        ? Colors.blue
                        : const Color.fromARGB(255, 32, 54, 70)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 32, 54, 70)),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            MaterialButton(
              color: const Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                Check();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
