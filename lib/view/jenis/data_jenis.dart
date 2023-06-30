import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:app_inventori/model/jenis_model.dart';
import 'package:app_inventori/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class DataJenis extends StatefulWidget {
  const DataJenis({Key? key}) : super(key: key);

  @override
  State<DataJenis> createState() => _DataJenisState();
}

class _DataJenisState extends State<DataJenis> {
  var loading = false;
  final list = <JenisModel>[];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  final logger = Logger();

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.get(Uri.parse(BaseUrl.urlDataJenis));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      logger.d('Data Respons: $data');

      for (var json in data) {
        final ab = JenisModel.fromJson(json);
        list.add(ab);
      }

      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Gagal mengambil data dari server.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _lihatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 41, 69, 91),
        title: const Text(
          "Data Jenis Barang",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add button pressed
        },
        backgroundColor: const Color.fromARGB(255, 41, 69, 91),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        key: _refresh,
        onRefresh: _lihatData,
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : (list.isEmpty
                ? const Center(
                    child: Text("Data kosong"),
                  )
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final x = list[i];
                      return Card(
                        color: const Color.fromARGB(255, 250, 248, 246),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                x.nama_jenis.toString(),
                              ),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // Edit button pressed
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Delete button pressed
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )),
      ),
    );
  }
}
