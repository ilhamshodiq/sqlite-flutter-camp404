import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static const String QUERY_TBL_PELANGGAN = """
  CREATE TABLE pelanggan(
    id INTEGER PRIMARY KEY,
    nama TEXT,
    gender TEXT,
    tgl_lhr TEXT
  )
  """;

  //method static untuk akses variable _db
  static Future<Database?> db() async {
    return _db ??= (await DBHelper().konekDB());
  }

  //method untuk koneksi ke fild DATABASE SQLite
  Future<Database> konekDB() async {
    return await openDatabase('dbsaya.db', version: 1, onCreate: (db, version) {
      db.execute(QUERY_TBL_PELANGGAN);
    });
  }
}
