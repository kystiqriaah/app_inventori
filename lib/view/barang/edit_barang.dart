import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import 'package:app_inventori/model/barang_model.dart';

class BaseUrl {
  static const String baseUrl = "http://192.168.1.105/flutter_inven/api";
  static const String imagePath = "http://192.168.1.105/flutter_inven/images";

  // Data jenis
  static const String urlDataJenis = "$baseUrl/jenis/data_jenis.php";
  static const String urlTambahJenis = "$baseUrl/jenis/tambah_jenis.php";
  static const String urlEditJenis = "$baseUrl/jenis/edit_jenis.php";
  static const String urlHapusJenis = "$baseUrl/jenis/delete_jenis.php";
  // End data jenis

  // Data admin
  static const String urlDataAdmin = "$baseUrl/admin/data_admin.php";
  static const String urlTambahAdmin = "$baseUrl/admin/tambah_admin.php";
  static const String urlEditAdmin = "$baseUrl/admin/edit_admin.php";
  static const String urlHapusAdmin = "$baseUrl/admin/delete_admin.php";
  // End Data admin

  // Level
  static const String urlDataLevel = "$baseUrl/level/data_level.php";
  // End Level

  // Login
  static const String urlLogin = "$baseUrl/auth/login.php";
  // End Login

  // statistik
  static String urlCount = "$baseUrl/statistik/count.php";

  // Data barang
  static const String urlDataBarang = "$baseUrl/barang/data_barang.php";
  static const String urlTambahBarang = "$baseUrl/barang/tambah_barang.php";
  static const String urlEditBarang = "$baseUrl/barang/edit_barang.php";
  static const String urlHapusBarang = "$baseUrl/barang/delete_barang.php";
  // End Data barang
}

class EditBarang extends StatefulWidget {
  final VoidCallback reload;
  final BarangModel model;

  const EditBarang(this.model, this.reload, {Key? key}) : super(key: key);

  @override
  State<EditBarang> createState() => _EditBarangState();
}

class _EditBarangState extends State<EditBarang> {
  final logger = Logger();

  FocusNode myFocusNode = FocusNode();

  String? id_barang, nama, brand, jenis;
  final _key = GlobalKey<FormState>();
  final image_picker = ImagePicker();

  TextEditingController? txtBarang;

  @override
  void initState() {
    super.initState();
    setup();
  }

  setup() async {
    txtBarang = TextEditingController(text: widget.model.nama_barang);
    id_barang = widget.model.id_barang;
  }

  _pilihGallery() async {
    final image = await image_picker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080);
    setState(() {
      if (image != null) {
        // Use the image file as needed
        // For example, display the image or upload it to a server
        Navigator.pop(context);
      } else {
        logger.d('No image selected');
      }
    });
  }

  _pilihCamera() async {
    final image = await image_picker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080);
    setState(() {
      if (image != null) {
        // Use the image file as needed
        // For example, display the image or upload it to a server
        Navigator.pop(context);
      } else {
        logger.d('No image selected');
      }
    });
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pilih sumber gambar"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text("Gallery"),
                  onTap: () {
                    _pilihGallery();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text("Camera"),
                  onTap: () {
                    _pilihCamera();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Peringatan"),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Apakah Anda yakin ingin menghapus data ini?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Ya"),
              onPressed: () {
                _deleteData(widget.model.id_barang);
                Navigator.pop(context);
                widget.reload();
              },
            ),
            TextButton(
              child: const Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _deleteData(String? id_barang) async {
    final response = await http.post(Uri.parse(BaseUrl.urlHapusBarang),
        body: {"id_barang": id_barang});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        widget.reload();
      });
    } else {
      logger.e(message);
    }
  }

  _editData() async {
    final response = await http.post(Uri.parse(BaseUrl.urlEditBarang), body: {
      "id_barang": widget.model.id_barang,
      "nama_barang": nama,
      "brand": brand,
      "jenis": jenis,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        widget.reload();
      });
    } else {
      logger.e(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Barang'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Form(
                  key: _key,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: txtBarang,
                        validator: (e) {
                          if (e!.isEmpty) {
                            return "Silahkan isi nama barang";
                          }
                          return null;
                        },
                        onSaved: (e) => nama = e,
                        onChanged: (String? value) {
                          setState(() {
                            nama = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Nama Barang",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: const Text("Upload Gambar"),
                        onPressed: () {
                          _showChoiceDialog(context);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            _key.currentState!.save();
                            _editData();
                          }
                        },
                        child: const Text(
                          "Edit Data",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          _showAlertDialog(context);
                        },
                        child: const Text(
                          "Hapus Data",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
