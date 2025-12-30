import 'package:agenda_app/app/views/messages/new_message_page.dart';
import 'package:agenda_app/app/views/tabs/tabs_page.dart';
import 'package:flutter/material.dart';
import 'app/views/auth/login_page.dart';
import 'app/views/auth/register_page.dart';
import 'app/views/pages/home/home_page.dart';

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
        '/home': (context) => const HomePage(),
        '/new_message': (context) => NewMessagePage(),
        '/tabs': (_) => const TabsPage(),
      },
    );
  }
}
