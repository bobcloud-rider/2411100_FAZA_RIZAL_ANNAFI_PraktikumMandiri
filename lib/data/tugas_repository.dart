import "package:sqflite/sqflite.dart";

import "../models/tugas.dart";
import "database_helper.dart";

class TugasRepository {
  final DatabaseHelper helper;
  TugasRepository(this.helper);

  Future<List<Tugas>> semua() async {
    final db = await helper.database;
    final baris = await db.query("tugas", orderBy: "deadline ASC, id DESC");
    return baris.map(Tugas.fromMap).toList();
  }

  Future<int> tambah(Tugas tugas) async {
    final db = await helper.database;
    return db.insert("tugas", tugas.toMap());
  }

  Future<int> ubah(Tugas tugas) async {
    if (tugas.id == null) throw ArgumentError("ID tugas tidak boleh kosong");
    final db = await helper.database;
    return db.update("tugas", tugas.toMap(), where: "id = ?", whereArgs: [tugas.id]);
  }

  Future<int> hapus(int id) async {
    final db = await helper.database;
    return db.delete("tugas", where: "id = ?", whereArgs: [id]);
  }
}
