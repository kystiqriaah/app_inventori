import 'data_jenis.dart' show DataJenis;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_inventori/model/api.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class TambahJenis extends StatefulWidget {
  const TambahJenis(Future<void> lihatData, {super.key});

  @override
  State<TambahJenis> createState() => _TambahJenisState();
}

class _TambahJenisState extends State<TambahJenis> {
  FocusNode myFocusNode = FocusNode();
  String? jenis;
  final _key = GlobalKey<FormState>();
  final Logger logger = Logger();
  
  get http => null;

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      simpanJenis();
    }
  }

  simpanJenis() async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.urlTambahJenis.toString()),
        body: {"jenis": jenis},
      );
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print(data);
      }
      int code = data['success'];
      String pesan = data['message'];
      logger.d(pesan);
      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DataJenis()),
          );
        });
      } else {
        logger.d(pesan);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
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
              "Tambah Jenis barang",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
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
                  return "Silahkan isi Jenis Barang";
                }
                return null;
              },
              onSaved: (e) => jenis = e,
              decoration: InputDecoration(
                labelText: 'Jenis Barang',
                labelStyle: TextStyle(
                  color: myFocusNode.hasFocus
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
              onPressed: check,
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
