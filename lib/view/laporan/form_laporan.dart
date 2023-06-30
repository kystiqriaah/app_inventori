import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_inventori/model/tanggal_model.dart';
import 'package:app_inventori/custome/datepicker.dart';
import 'package:app_inventori/view/laporan/laporan_page.dart';

class FormLaporan extends StatefulWidget {
  const FormLaporan({Key? key}) : super(key: key);

  @override
  _FormLaporanState createState() => _FormLaporanState();
}

class _FormLaporanState extends State<FormLaporan> {
  final _key = GlobalKey<FormState>();
  late String pilihTanggal, labelText;
  late DateTime tgl1;
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  late String Tanggal2, labelText2;
  late DateTime tgl2;
  final TextStyle valueStyle2 = TextStyle(fontSize: 16.0);

  @override
  void initState() {
    super.initState();
    tgl1 = DateTime.now();
    tgl2 = DateTime.now();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl1,
      firstDate: DateTime(1990),
      lastDate: DateTime(2099),
    );
    if (picked != null && picked != tgl1) {
      setState(() {
        tgl1 = picked;
      });
      pilihTanggal = DateFormat.yMd().format(tgl1);
    } else {}
  }

  Future<Null> _selectDate2(BuildContext context) async {
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
      Tanggal2 = DateFormat.yMd().format(tgl2);
    } else {}
  }

  void send() {
    TanggalModel tanggalModel = TanggalModel(pilihTanggal, Tanggal2);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LaporanPage(tanggalModel: tanggalModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 41, 69, 91),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Form Laporan Barang Masuk",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            DateDropDown(
              labelText: "Dari",
              valueText: DateFormat.yMd().format(tgl1),
              valueStyle: valueStyle,
              onPressed: () {
                _selectDate(context);
              },
            ),
            SizedBox(height: 20),
            DateDropDown(
              labelText: "Sampai",
              valueText: DateFormat.yMd().format(tgl2),
              valueStyle: valueStyle2,
              onPressed: () {
                _selectDate2(context);
              },
            ),
            SizedBox(height: 25),
            MaterialButton(
              color: Color.fromARGB(255, 41, 69, 91),
              onPressed: send,
              child: Text(
                "Laporan",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
