import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../models/tugas.dart";
import "../viewmodels/tugas_view_model.dart";
import "form_tugas_page.dart";

class DetailTugasPage extends StatelessWidget {
  final int id;
  const DetailTugasPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Detail Tugas")),
        body: Consumer<TugasViewModel>(builder: (context, vm, _) {
          Tugas? tugas;
          for (final item in vm.tugas) {
            if (item.id == id) {
              tugas = item;
              break;
            }
          }
          if (tugas == null) {
            return const Center(child: Text("Tugas tidak ditemukan."));
          }
          final data = tugas;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Icon(_iconStatus(data.status), color: _warnaStatus(data.status)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(data.mataKuliah,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(data.judul, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text("Deadline: ${data.deadline.day}/${data.deadline.month}/${data.deadline.year}"),
              Text("Prioritas: ${data.prioritas.name}"),
              Text("Status: ${data.status.name}"),
              const Divider(height: 32),
              Text(data.deskripsi),
              const SizedBox(height: 28),
              FilledButton.tonalIcon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FormTugasPage(awal: data)),
                ),
                icon: const Icon(Icons.edit),
                label: const Text("Ubah"),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => _konfirmasiHapus(context, vm, data.id!),
                icon: const Icon(Icons.delete_outline),
                label: const Text("Hapus"),
              ),
            ],
          );
        }),
      );

  IconData _iconStatus(StatusTugas s) {
    if (s == StatusTugas.belum) return Icons.radio_button_unchecked_rounded;
    if (s == StatusTugas.proses) return Icons.hourglass_top_rounded;
    return Icons.check_circle_outline_rounded;
  }

  Color _warnaStatus(StatusTugas s) {
    if (s == StatusTugas.belum) return Colors.grey;
    if (s == StatusTugas.proses) return Colors.orange;
    return Colors.green;
  }

  Future<void> _konfirmasiHapus(
      BuildContext context, TugasViewModel vm, int id) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Hapus tugas?"),
        content: const Text("Tugas yang dihapus tidak dapat dikembalikan."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text("Batal")),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text("Hapus")),
        ],
      ),
    );
    if (yakin != true || !context.mounted) return;
    try {
      await vm.hapusTugas(id);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal menghapus: $e")));
    }
  }
}
