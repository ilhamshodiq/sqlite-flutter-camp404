import 'package:flutter/material.dart';
import 'package:prakteksqlite/helper/dbhelper.dart';
import 'package:prakteksqlite/pages/pelanggan/pelanggan_cari.dart';
import 'package:prakteksqlite/pages/pelanggan/pelanggan_form.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PelangganList extends StatefulWidget {
  @override
  _PelangganListState createState() => _PelangganListState();
}

class _PelangganListState extends State<PelangganList> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List<Map> listData = [];

  void refresh() async {
    final _db = await DBHelper.db(); //dapatkan objek database

    final sql = 'SELECT * FROM pelanggan';
    listData = (await _db?.rawQuery(sql))!; //jalankan query
    _refreshController.refreshCompleted(); //tandai bila proses refresh selesai
    setState(() {}); //render ulang untuk menampilkan perubahan data
  }

  Future<bool> hapusData(int id) async {
    final _db = await DBHelper.db();
    final count =
        await _db?.delete('pelanggan', where: 'id=?', whereArgs: [id]);
    return count! > 0;
  }


  Widget item(Map d) => ListTile(
        onLongPress: () {
          showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                  100, MediaQuery.of(context).size.height / 2, 100, 0),
              items: [
                PopupMenuItem(
                  child: Text('Sunting data ini'),
                  value: 'S',
                ),
                PopupMenuItem(
                  child: Text('Hapus data ini'),
                  value: 'H',
                )
              ]).then((value) {
            if (value == 'S') {
              Navigator.push(context,
                      MaterialPageRoute(builder: (c) => PelangganForm(data: d)))
                  .then((value) {
                if (value == true) refresh();
              });
            } else if (value == 'H') {
              showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                        content: Text('Pelanggan ${d['nama']} ingin dihapus?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                hapusData(d['id']).then((value) {
                                  if (value == true) refresh();
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Ya, saya yakin banget')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Tidak jadi deh...')),
                        ],
                      ));
            }
          });
        },
        leading: PopupMenuButton(
          itemBuilder: (bc) => [
            PopupMenuItem(
              child: Text('Sunting data ini'),
              value: 'S',
            ),
            PopupMenuItem(
              child: Text('Hapus data ini'),
              value: 'H',
            )
          ],
          onSelected: (value) {
            if (value == 'S') {
              Navigator.push(context,
                      MaterialPageRoute(builder: (c) => PelangganForm(data: d)))
                  .then((value) {
                if (value == true) refresh();
              });
            } else if (value == 'H') {
              showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                        content: Text('Pelanggan ${d['nama']} ingin dihapus?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                hapusData(d['id']).then((value) {
                                  if (value == true) refresh();
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Ya, saya yakin banget')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Tidak jadi deh...')),
                        ],
                      ));
            }
          },
        ),
        title: Text('${d['nama']}'),
        trailing: Text('${d['gender']}'),
        subtitle: Text('${d['tgl_lhr']}'),
      );

  Widget tombohTambah() => ElevatedButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (c) => PelangganForm()))
              .then((value) {
            if (value == true) {
              refresh();
            }
          });
        },
        child: Text('Tambah Pelanggan'),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Pelanggan', style: TextStyle(fontSize: 18, color: Colors.amber, fontStyle: FontStyle.italic),),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => PelangganCari()));
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      floatingActionButton: tombohTambah(),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () => refresh(),
        child: ListView(
          children: [for (Map d in listData) item(d)],
        ),
      ),
    );
  }
}
