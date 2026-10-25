import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../models/tugas.dart";
import "../viewmodels/tugas_view_model.dart";

class FormTugasPage extends StatefulWidget {
  final Tugas? awal;
  const FormTugasPage({super.key, this.awal});

  @override
  State<FormTugasPage> createState() => _FormTugasPageState();
}

class _FormTugasPageState extends State<FormTugasPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _mataKuliah;
  late final TextEditingController _judul;
  late final TextEditingController _deskripsi;
  late final TextEditingController _deadline;
  late Prioritas _prioritas;
  late StatusTugas _status;
  bool _menyimpan = false;

  @override
  void initState() {
    super.initState();
    _mataKuliah = TextEditingController(text: widget.awal?.mataKuliah ?? "");
    _judul = TextEditingController(text: widget.awal?.judul ?? "");
    _deskripsi = TextEditingController(text: widget.awal?.deskripsi ?? "");
    _deadline = TextEditingController(
      text: widget.awal?.deadline.toIso8601String().substring(0, 10) ??
          DateTime.now().toIso8601String().substring(0, 10),
    );
    _prioritas = widget.awal?.prioritas ?? Prioritas.menengah;
    _status = widget.awal?.status ?? StatusTugas.belum;
  }

  @override
  void dispose() {
    _mataKuliah.dispose();
    _judul.dispose();
    _deskripsi.dispose();
    _deadline.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate() || _menyimpan) return;
    setState(() => _menyimpan = true);
    final data = Tugas(
      id: widget.awal?.id,
      mataKuliah: _mataKuliah.text.trim(),
      judul: _judul.text.trim(),
      deskripsi: _deskripsi.text.trim(),
      deadline: DateTime.tryParse(_deadline.text) ?? DateTime.now(),
      prioritas: _prioritas,
      status: _status,
    );
    try {
      final vm = context.read<TugasViewModel>();
      if (widget.awal == null) {
        await vm.tambahTugas(data);
      } else {
        await vm.ubahTugas(data);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal menyimpan: $e")));
    } finally {
      if (mounted) setState(() => _menyimpan = false);
    }
  }

  Widget _input(TextEditingController kontrol, String label, {int baris = 1}) {
    return TextFormField(
      controller: kontrol,
      maxLines: baris,
      decoration: InputDecoration(labelText: label),
      validator: (teks) =>
          (teks == null || teks.trim().isEmpty) ? "$label wajib diisi" : null,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.awal == null ? "Tambah Tugas" : "Ubah Tugas"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _input(_mataKuliah, "Mata kuliah"),
                  const SizedBox(height: 14),
                  _input(_judul, "Judul tugas"),
                  const SizedBox(height: 14),
                  _input(_deskripsi, "Deskripsi", baris: 5),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _deadline,
                    decoration: const InputDecoration(
                      labelText: "Tanggal deadline (YYYY-MM-DD)",
                      helperText: "Format: YYYY-MM-DD, contoh: 2026-11-01",
                    ),
                    validator: (teks) {
                      if (teks == null || teks.trim().isEmpty) return "Wajib diisi";
                      return DateTime.tryParse(teks.trim()) == null
                          ? "Format tanggal salah"
                          : null;
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<Prioritas>(
                    value: _prioritas,
                    decoration: const InputDecoration(labelText: "Prioritas"),
                    items: Prioritas.values
                        .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                        .toList(),
                    onChanged: (v) =>
                        v != null ? setState(() => _prioritas = v) : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<StatusTugas>(
                    value: _status,
                    decoration: const InputDecoration(labelText: "Status"),
                    items: StatusTugas.values
                        .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                        .toList(),
                    onChanged: (v) =>
                        v != null ? setState(() => _status = v) : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: _menyimpan ? null : _simpan,
              icon: const Icon(Icons.save),
              label: Text(_menyimpan ? "Menyimpan..." : "Simpan"),
            ),
          ],
        ),
      );
}
