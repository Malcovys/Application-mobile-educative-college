import 'package:flutter/material.dart';
import '../pages/home_page.dart';

import './db/services/database_chapitre_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseChapitreService.initialize();
  DatabaseChapitreService.getStoredChapitresOfMatiere(1);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduLearn - Apprendre Ensemble',
      themeMode: ThemeMode.system,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
