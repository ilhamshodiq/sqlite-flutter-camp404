import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prakteksqlite/helper/dbhelper.dart';

class PelangganForm extends StatefulWidget {
  final Map? data;

  PelangganForm({this.data}); //menerima data dari luar widget

  @override
  _PelangganFormState createState() => _PelangganFormState(this.data);
}

class _PelangganFormState extends State<PelangganForm> {
  final Map? data;
  late TextEditingController txtID, txtNama, txtTgllhr;
  String gender = '', tglLhr = '';

  _PelangganFormState(this.data) {
    txtID = TextEditingController(text: '${this.data?['id'] ?? ''}');
    txtNama = TextEditingController(text: this.data?['nama'] ?? '');
    txtTgllhr = TextEditingController(text: this.data?['tgl_lhr'] ?? '');
    gender = this.data?['gender'] ?? '';

    if (this.data == null) {
      lastID().then((value) {
        txtID.text = '${value + 1}';
      });
    }

    lastID().then((value) {
      txtID.text = '${value + 1}';
    });
  }

  Widget txtInputID() => TextFormField(
        controller: txtID,
        readOnly: true,
        decoration: InputDecoration(labelText: 'ID Pelanggan'),
      );

  Widget txtInputNama() => TextFormField(
        controller: txtNama,
        decoration: InputDecoration(labelText: 'Nama Pelanggan'),
      );

  Widget dropDownGender() => DropdownButtonFormField(
        decoration: InputDecoration(labelText: 'Jenis Kelamin'),
        isExpanded: true,
        value: gender,
        onChanged: (g) {
          gender = '$g';
        },
        items: [
          DropdownMenuItem(
            child: Text('Pilih Gender'),
            value: '',
          ),
          DropdownMenuItem(
            child: Text('Laki-Laki'),
            value: 'L',
          ),
          DropdownMenuItem(
            child: Text('Perempuan'),
            value: 'P',
          ),
        ],
      );

  DateTime initTgllhr() {
    try {
      return DateFormat('yyyy-MM-dd').parse(txtTgllhr.value.text);
    } catch (e) {
      return DateTime.now();
    }
  }

  Widget txtInputTglLhr() => TextFormField(
        readOnly: true,
        decoration: InputDecoration(labelText: 'Tanggal Lahir'),
        controller: txtTgllhr,
        onTap: () async {
          final tgl = await showDatePicker(
              context: context,
              initialDate: initTgllhr(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now());
          if (tgl != null)
            txtTgllhr.text = DateFormat('yyyy-MM-dd').format(tgl);
        },
      );

//method untuk mengetahui id terakhir di form
  Future<int> lastID() async {
    try {
      final _db = await DBHelper.db();
      final query = 'SELECT MAX(id) as id FROM pelanggan';
      final ls = (await _db?.rawQuery(query))!;

      if (ls.length > 0) {
        return int.tryParse('${ls[0]['id']}') ?? 0;
      }
    } catch (e) {
      print('error lastid $e');
    }
    return 0;
  }

  Future<bool> simpanData() async {
    try {
      final _db = await DBHelper.db();
      var data = {
        'id': txtID.value.text,
        'nama': txtNama.value.text,
        'gender': gender,
        'tgl_lhr': txtTgllhr.value.text,
      };
      final id = this.data == null
          ? await _db?.insert('pelanggan', data)
          : await _db?.update('pelanggan', data,
              where: 'id?', whereArgs: [this.data?['id']]);
      return id! > 0;
    } catch (e) {}
    return false;
  }

  Widget aksiSimpan() => TextButton(
      onPressed: () {
        simpanData().then((h) {
          var pesan = h == true ? 'Sukses simpan' : 'Gagal simpan';

          showDialog(
              context: context,
              builder: (bc) => AlertDialog(
                    title: Text('Simpan Pelanggan'),
                    content: Text('$pesan'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Oke...'))
                    ],
                  )).then((value) {
            Navigator.pop(context, h);
          });
        });
      },
      child: Text(
        'Simpan',
        style: TextStyle(color: Colors.white),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Pelanggan'),
        actions: [aksiSimpan()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            txtInputID(),
            txtInputNama(),
            dropDownGender(),
            txtInputTglLhr()
          ],
        ),
      ),
    );
  }
}
