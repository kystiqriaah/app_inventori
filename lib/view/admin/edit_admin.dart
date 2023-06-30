import 'dart:convert';
import 'package:app_inventori/model/admin_model.dart';
import 'package:app_inventori/model/api.dart';
import 'package:app_inventori/model/level_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class EditAdmin extends StatefulWidget {
  final VoidCallback reload;
  final AdminModel model;

  const EditAdmin(this.model, this.reload, {super.key});

  @override
  State<EditAdmin> createState() => _EditAdminState();
}

class _EditAdminState extends State<EditAdmin> {
  FocusNode myFocusNode = FocusNode();
  String? id_admin, nama, username, level;
  final _key = GlobalKey<FormState>();
  TextEditingController? txtNamaAdmin, txtUsername;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    setup();
  }

  void setup() {
    txtUsername = TextEditingController(text: widget.model.username);
    txtNamaAdmin = TextEditingController(text: widget.model.nama);
    id_admin = widget.model.id_admin;
  }

  LevelModel? _currentLevel;
  final String? linkLevel = BaseUrl.urlDataLevel;

  Future<List<LevelModel>> _fetchLevel() async {
    var response = await http.get(Uri.parse(linkLevel.toString()));
    logger.d('hasil: ${response.statusCode}');
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<LevelModel> listOfLevel = items.map<LevelModel>((json) {
        return LevelModel.fromJson(json);
      }).toList();
      return listOfLevel;
    } else {
      throw Exception('gagal');
    }
  }

  void check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      prosesUp();
    }
  }

  void prosesUp() async {
    try {
      final response = await http.post(
        Uri.parse(BaseUrl.urlEditAdmin.toString()),
        body: {
          "id_admin": id_admin,
          "nama": nama,
          "username": username,
          "level": level
        },
      );
      final data = jsonDecode(response.body);
      logger.d(data);
      int code = data['success'];
      String pesan = data['message'];
      logger.d(data);
      if (code == 1) {
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        logger.d(pesan);
      }
    } catch (e) {
      logger.e(e.toString());
    }
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
              "Edit Admin",
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
              controller: txtNamaAdmin,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Silahkan isi Nama";
                } else {
                  return null;
                }
              },
              onSaved: (value) => nama = value,
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
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 32, 54, 70)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: txtUsername,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Silahkan isi Username";
                } else {
                  return null;
                }
              },
              onSaved: (e) => username = e,
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
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 32, 54, 70)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<LevelModel>>(
              future: _fetchLevel(),
              builder: (BuildContext context, AsyncSnapshot<List<LevelModel>> snapshot) {
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
                          level = _currentLevel!.id_level;
                        });
                      },
                      isExpanded: true,
                      value: _currentLevel,
                      hint: Text(
                        level == null || level == widget.model.level
                            ? widget.model.level.toString()
                            : _currentLevel!.lvl.toString(),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 25),
            MaterialButton(
              color: const Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                check();
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
