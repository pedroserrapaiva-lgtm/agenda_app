import 'package:agenda_app/app/views/tabs/tabs_page.dart';
import 'package:flutter/material.dart';
import 'app/views/auth/login_page.dart';
import 'app/views/auth/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      

      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const RegisterPage(),
        '/tabs': (_) => const TabsPage(),
      },
    );
  }
}
