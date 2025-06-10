import 'package:application_mobile_educative_college/widgets/navbar.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduLearn - Apprendre Ensemble',
      themeMode: ThemeMode.system,
      home: const NavBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}
