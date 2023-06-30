import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:app_inventori/model/brand_model.dart';
import 'package:app_inventori/model/jenis_model.dart';
import 'package:app_inventori/model/api.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'data_barang.dart';

class TambahBarang extends StatefulWidget {
  final VoidCallback reload;

  const TambahBarang(this.reload, {super.key});

  @override
  State<TambahBarang> createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarang> {
  FocusNode myFocusNode = FocusNode();

  String? barang, jenisB, brandB;

  final _key = GlobalKey<FormState>();

  File? _imageFile;

  final imagePicker = ImagePicker();

  Future<void> _pilihGallery() async {
    final image = await imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080);
    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
        Navigator.pop(context);
      } else {
        logger.d('No image selected');
      }
    });
  }

  Future<void> _pilihCamera() async {
    final image = await imagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080);
    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
        Navigator.pop(context);
      } else {
        logger.d('No image selected');
      }
    });
  }

  JenisModel? _currentJenis;
  final String linkJenis = BaseUrl.urlDataJenis;

  Future<List<JenisModel>> _fetchJenis() async {
    var response = await http.get(Uri.parse(linkJenis));
    logger.d('hasil: ${response.statusCode.toString()}');
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<JenisModel> listOfJenis = items.map<JenisModel>((json) {
        return JenisModel.fromJson(json);
      }).toList();
      return listOfJenis;
    } else {
      throw Exception('gagal');
    }
  }

  BrandModel? _currentBrand;
  final String linkBrand = BaseUrl.urlDataBrand;

  Future<List<BrandModel>> _fetchBrand() async {
    var response = await http.get(Uri.parse(linkBrand));
    logger.d('hasil: ${response.statusCode.toString()}');
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<BrandModel> listOfBrand = items.map<BrandModel>((json) {
        return BrandModel.fromJson(json);
      }).toList();
      return listOfBrand;
    } else {
      throw Exception('gagal');
    }
  }

  void check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      Simpan();
    }
  }

  void Simpan() async {
    try {
      var stream = http.ByteStream(Stream.castFrom(_imageFile!.openRead()));
      var length = await _imageFile!.length();
      var uri = Uri.parse(BaseUrl.urlTambahBarang);
      var request = http.MultipartRequest("POST", uri);
      var multipartFile = http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile!.path));
      request.fields['nama_barang'] = barang!;
      request.fields['id_jenis'] = _currentJenis!.id_jenis.toString();
      request.fields['id_brand'] = _currentBrand!.id_brand.toString();
      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        logger.i("Upload Image Success");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        logger.e("Upload Failed");
      }
    } catch (e) {
      logger.e("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Barang'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Form(
          key: _key,
          child: ListView(
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              TextFormField(
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'Masukkan Nama Barang';
                  }
                  return null;
                },
                onSaved: (e) => barang = e,
                decoration: InputDecoration(
                  labelText: 'Nama Barang',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              FutureBuilder<List<JenisModel>>(
                future: _fetchJenis(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return DropdownButtonFormField<JenisModel>(
                    items: snapshot.data!
                        .map((item) => DropdownMenuItem<JenisModel>(
                              value: item,
                              child: Text(item.nama_jenis!),
                            ))
                        .toList(),
                    onChanged: (JenisModel? value) {
                      setState(() {
                        _currentJenis = value;
                      });
                    },
                    value: _currentJenis,
                    decoration: InputDecoration(
                      labelText: 'Jenis Barang',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  );
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              FutureBuilder<List<BrandModel>>(
                future: _fetchBrand(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return DropdownButtonFormField<BrandModel>(
                    items: snapshot.data!
                        .map((item) => DropdownMenuItem<BrandModel>(
                              value: item,
                              child: Text(item.brand!),
                            ))
                        .toList(),
                    onChanged: (BrandModel? value) {
                      setState(() {
                        _currentBrand = value;
                      });
                    },
                    value: _currentBrand,
                    decoration: InputDecoration(
                      labelText: 'Brand Barang',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  );
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      _pilihGallery();
                    },
                    icon: const Icon(FontAwesomeIcons.image),
                    label: const Text('Gallery'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _pilihCamera();
                    },
                    icon: const Icon(FontAwesomeIcons.camera),
                    label: const Text('Camera'),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              _imageFile == null
                  ? const Text('No Image Selected')
                  : Image.file(
                      _imageFile!,
                      height: 300,
                    ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              ElevatedButton(
                onPressed: () {
                  check();
                },
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
