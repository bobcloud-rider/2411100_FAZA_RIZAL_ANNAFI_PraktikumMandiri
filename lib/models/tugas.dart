enum Prioritas { rendah, menengah, tinggi }
enum StatusTugas { belum, proses, selesai }

class Tugas {
  final int? id;
  final String mataKuliah;
  final String judul;
  final String deskripsi;
  final DateTime deadline;
  final Prioritas prioritas;
  final StatusTugas status;

  const Tugas({
    this.id,
    required this.mataKuliah,
    required this.judul,
    required this.deskripsi,
    required this.deadline,
    required this.prioritas,
    required this.status,
  });

  Map<String, Object?> toMap() => {
        if (id != null) "id": id,
        "mata_kuliah": mataKuliah,
        "judul": judul,
        "deskripsi": deskripsi,
        "deadline": deadline.toIso8601String(),
        "prioritas": prioritas.name,
        "status": status.name,
      };

  factory Tugas.fromMap(Map<String, Object?> data) => Tugas(
        id: data["id"] as int?,
        mataKuliah: data["mata_kuliah"] as String,
        judul: data["judul"] as String,
        deskripsi: data["deskripsi"] as String,
        deadline: DateTime.parse(data["deadline"] as String),
        prioritas: Prioritas.values.firstWhere((e) => e.name == data["prioritas"] as String),
        status: StatusTugas.values.firstWhere((e) => e.name == data["status"] as String),
      );
}
