import 'package:flutter/material.dart';
// import '../widgets/navbar.dart';
import 'services/auth_service.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduLearn - Apprendre Ensemble',
      themeMode: ThemeMode.system,
      home: AuthService.isAuth ? const HomePage() : const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
