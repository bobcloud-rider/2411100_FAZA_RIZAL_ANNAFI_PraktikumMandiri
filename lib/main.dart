import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "data/database_helper.dart";
import "data/tugas_repository.dart";
import "screens/daftar_tugas_page.dart";
import "viewmodels/tugas_view_model.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) =>
          TugasViewModel(TugasRepository(DatabaseHelper.instance))..muatTugas(),
      child: const ManajemenTugasApp(),
    ),
  );
}

class ManajemenTugasApp extends StatelessWidget {
  const ManajemenTugasApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Manajemen Tugas",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF4158D0),
          useMaterial3: true,
          inputDecorationTheme:
              const InputDecorationTheme(border: OutlineInputBorder()),
        ),
        home: const DaftarTugasPage(),
      );
}
