import 'package:flutter/material.dart';
import 'package:app_inventori/model/barang_model.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class DetailBarang extends StatefulWidget {
  final VoidCallback reload;
  final BarangModel model;

  DetailBarang(this.model, this.reload);

  @override
  State<DetailBarang> createState() => _DetailBarangState();
}

class _DetailBarangState extends State<DetailBarang> {
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
              child: Text(
                "Detail Barang ${widget.model.id_barang.toString()}",
                style: const TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 250.0,
                child: InkWell(
                  onTap: () {
                    showImageViewer(
                      context,
                      Image.network('<replace-with-image-url>').image,
                      swipeDismissible: true,
                    );
                  },
                  child: Image.network(
                    '<replace-with-image-url>',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(children: <Widget>[
                    const ListTile(title: Text("Id Barang")),
                    ListTile(
                      title: Text(
                        widget.model.id_barang.toString(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ]),
                  TableRow(children: <Widget>[
                    const ListTile(title: Text("Nama Barang")),
                    ListTile(
                      title: Text(
                        widget.model.nama_barang.toString(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ]),
                  TableRow(children: <Widget>[
                    const ListTile(title: Text("Jenis")),
                    ListTile(
                      title: Text(
                        widget.model.nama_jenis.toString(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ]),
                  TableRow(children: <Widget>[
                    const ListTile(title: Text("Brand")),
                    ListTile(
                      title: Text(
                        widget.model.nama_brand.toString(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
