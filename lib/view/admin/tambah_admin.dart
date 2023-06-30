import 'package:app_inventori/model/api.dart';
import 'package:app_inventori/model/level_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class TambahAdmin extends StatefulWidget {
  final VoidCallback reload;

  const TambahAdmin(this.reload, {Key? key}) : super(key: key);

  @override
  State<TambahAdmin> createState() => _TambahAdminState();
}

class _TambahAdminState extends State<TambahAdmin> {
  FocusNode myFocusNode = FocusNode();
  String? nama, username, password, level;
  final _formKey = GlobalKey<FormState>();
  LevelModel? _currentLevel;
  final String? linkLevel = BaseUrl.urlDataLevel;

  final Logger logger = Logger();

  Future<List<LevelModel>> _fetchLevel() async {
    var response = await http.get(Uri.parse(linkLevel.toString()));
    logger.d('hasil ${response.statusCode}');
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<LevelModel> listOfLevel = items.map<LevelModel>((json) {
        return LevelModel.fromJson(json);
      }).toList();
      return listOfLevel;
    } else {
      throw Exception('Gagal');
    }
  }

  void check() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      simpan();
    }
  }

  void simpan() async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.urlTambahAdmin.toString()),
        body: {
          "nama_admin": nama,
          "username": username,
          "password": password,
          "level": _currentLevel?.id_level,
        },
      );
      final data = jsonDecode(response.body);
      logger.d(data);
      int code = data['success'];
      String pesan = data['message'];
      logger.d(data);
      if (code == 1) {
        setState(() {
          Navigator.pop(context);
          widget.reload();
        });
      } else {
        logger.d(pesan);
      }
    } catch (e) {
      logger.e(e.toString());
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
        backgroundColor: const Color.fromARGB(255, 41, 69, 91),
        title: const Text(
          "Tambah Admin",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Silahkan isi nama";
                }
                return null;
              },
              onSaved: (value) => nama = value,
              focusNode: myFocusNode,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
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
                      color: Color.fromARGB(255, 32, 54, 70)),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Silahkan isi username";
                }
                return null;
              },
              onSaved: (value) => username = value,
              focusNode: myFocusNode,
              decoration: InputDecoration(
                labelText: 'Username',
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
                      color: Color.fromARGB(255, 32, 54, 70)),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Silahkan isi password";
                }
                return null;
              },
              onSaved: (value) => password = value,
              focusNode: myFocusNode,
              decoration: InputDecoration(
                labelText: 'Password',
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
                      color: Color.fromARGB(255, 32, 54, 70)),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            FutureBuilder<List<LevelModel>>(
              future: _fetchLevel(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: const Color.fromARGB(255, 32, 54, 70),
                          width: 0.80),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<LevelModel>(
                        items: snapshot.data!.map((listLevel) {
                          return DropdownMenuItem<LevelModel>(
                            value: listLevel,
                            child: Text(listLevel.lvl.toString()),
                          );
                        }).toList(),
                        onChanged: (LevelModel? value) {
                          setState(() {
                            _currentLevel = value;
                            level = _currentLevel?.id_level;
                          });
                        },
                        isExpanded: true,
                        hint: Text(
                            level == null ? "Pilih Level" : _currentLevel?.lvl ?? "Pilih Level"),
                      ),
                    ),
                  );
                }
              },
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
                  borderRadius: BorderRadius.circular(10)),
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Additional TextFormField widgets go here
          ],
        ),
      ),
    );
  }
}
