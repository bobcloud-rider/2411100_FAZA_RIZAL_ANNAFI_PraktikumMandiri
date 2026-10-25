import "package:flutter/foundation.dart";

import "../data/tugas_repository.dart";
import "../models/tugas.dart";

class TugasViewModel extends ChangeNotifier {
  final TugasRepository repository;
  TugasViewModel(this.repository);

  List<Tugas> _tugas = [];
  List<Tugas> get tugas => List.unmodifiable(_tugas);
  bool isLoading = false;
  String? error;

  Future<void> muatTugas() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      _tugas = await repository.semua();
    } catch (e) {
      error = "Tidak dapat membaca tugas: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> tambahTugas(Tugas baru) async {
    await repository.tambah(baru);
    await muatTugas();
  }

  Future<void> ubahTugas(Tugas tugas) async {
    await repository.ubah(tugas);
    await muatTugas();
  }

  Future<void> hapusTugas(int id) async {
    await repository.hapus(id);
    await muatTugas();
  }
}
