import "package:flutter_test/flutter_test.dart";
import "package:praktikum_tugas_mhs/models/tugas.dart";

void main() {
  test("Tugas round-trip Map tidak mengubah data", () {
    final asli = Tugas(
      id: 7,
      mataKuliah: "Pemrograman Mobile",
      judul: "Tugas Praktikum",
      deskripsi: "CRUD offline",
      deadline: DateTime(2026, 11, 1),
      prioritas: Prioritas.tinggi,
      status: StatusTugas.proses,
    );
    final hasil = Tugas.fromMap(asli.toMap());
    expect(hasil.id, 7);
    expect(hasil.judul, "Tugas Praktikum");
    expect(hasil.mataKuliah, "Pemrograman Mobile");
    expect(hasil.prioritas, Prioritas.tinggi);
    expect(hasil.status, StatusTugas.proses);
  });
}
