import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_inventori/model/tanggal_model.dart';
import 'package:app_inventori/custome/datePicker.dart';
import 'package:app_inventori/view/laporan/laporanBk.dart';

class FormLbk extends StatefulWidget {
  const FormLbk({Key? key}) : super(key: key);

  @override
  State<FormLbk> createState() => _FormLbkState();
}

class _FormLbkState extends State<FormLbk> {
  final _key = GlobalKey<FormState>();
  String? pilihTanggal, labelText;
  DateTime tgl1 = DateTime.now();
  DateTime tgl2 = DateTime.now();

  final TextStyle valueStyle = const TextStyle(fontSize: 16.0);
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl1,
      firstDate: DateTime(1990),
      lastDate: DateTime(2099),
    );

    if (picked != null && picked != tgl1) {
      setState(() {
        tgl1 = picked;
        pilihTanggal = DateFormat.yMd().format(tgl1);
      });
    }
  }

  Future<Null> _selectedDate2(BuildContext context) async {
    final DateTime? picked2 = await showDatePicker(
      context: context,
      initialDate: tgl2,
      firstDate: DateTime(1990),
      lastDate: DateTime(2099),
    );

    if (picked2 != null && picked2 != tgl2) {
      setState(() {
        tgl2 = picked2;
      });
    }
  }

  void send() {
    TanggalModel tanggalModel = TanggalModel("$tgl1", "$tgl2");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LaporanBk(tanggalModel: tanggalModel),
      ),
    );
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
                "Form Laporan Barang Keluar",
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
            DateDropDown(
              labelText: "Dari",
              valueText: DateFormat.yMd().format(tgl1),
              valueStyle: valueStyle,
              onPressed: () {
                _selectedDate(context);
              },
            ),
            const SizedBox(height: 20),
            DateDropDown(
              labelText: "Sampai",
              valueText: DateFormat.yMd().format(tgl2),
              valueStyle: valueStyle,
              onPressed: () {
                _selectedDate2(context);
              },
            ),
            const SizedBox(height: 25),
            MaterialButton(
              color: const Color.fromARGB(255, 41, 69, 91),
              onPressed: () {
                send();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Laporan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
