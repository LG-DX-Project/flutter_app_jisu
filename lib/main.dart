// lib/main.dart
import 'package:flutter/material.dart';

// 각 화면 import
import 'features/auth/login_page.dart';
import 'features/auth/loading_page.dart';
import 'features/auth/loading_id_page.dart';
import 'features/mode/type_select_page.dart';
import 'features/screens/next/next_page.dart';
import 'features/screens/home/home_page.dart';
import 'features/screens/result/result_page.dart';

void main() {
  runApp(const MyApp());
}

// 👉 앱 전체 설정 + 라우팅만 담당
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LG_TV MVP',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/loading': (context) => const LoadingPage(),
        '/login-select': (context) => const LoginSelectPage(),
        '/mode-select': (context) => const ModeSelectPage(),
        '/next': (context) => const NextPage(),
        '/home': (context) => const HomePage(),
        '/result': (context) => const ResultPage(),
      },
    );
  }
}
