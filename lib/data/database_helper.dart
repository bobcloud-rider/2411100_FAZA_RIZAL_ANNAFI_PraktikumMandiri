import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final filePath = join(await getDatabasesPath(), "tugas_mhs.db");
    _database = await openDatabase(
      filePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE tugas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mata_kuliah TEXT NOT NULL,
            judul TEXT NOT NULL,
            deskripsi TEXT NOT NULL,
            deadline TEXT NOT NULL,
            prioritas TEXT NOT NULL,
            status TEXT NOT NULL
          )
        """);
      },
    );
    return _database!;
  }
}
