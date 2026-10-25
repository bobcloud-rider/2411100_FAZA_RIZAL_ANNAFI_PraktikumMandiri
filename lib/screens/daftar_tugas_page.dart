import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../viewmodels/tugas_view_model.dart";
import "detail_tugas_page.dart";
import "form_tugas_page.dart";

class DaftarTugasPage extends StatelessWidget {
  const DaftarTugasPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Daftar Tugas")),
        body: Consumer<TugasViewModel>(builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(vm.error!, textAlign: TextAlign.center),
                  TextButton(onPressed: vm.muatTugas, child: const Text("Coba lagi")),
                ],
              ),
            );
          }
          if (vm.tugas.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text("Belum ada tugas. Tekan + untuk menambah tugas.",
                    textAlign: TextAlign.center),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: vm.tugas.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final tugas = vm.tugas[index];
              return Card(
                child: ListTile(
                  title: Text(tugas.judul),
                  subtitle: Text("${tugas.mataKuliah} • ${tugas.status.name}"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailTugasPage(id: tugas.id!)),
                  ),
                ),
              );
            },
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormTugasPage()),
          ),
          icon: const Icon(Icons.add),
          label: const Text("Tambah"),
        ),
      );
}
