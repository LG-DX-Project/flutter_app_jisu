// lib/main.dart
import 'package:flutter/material.dart';

// 각 화면 import
import 'screens/login/login_page.dart';
import 'screens/loading/loading_page.dart';
import 'screens/next/next_page.dart';
import 'screens/home/home_page.dart';
import 'screens/result/result_page.dart';

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
        '/next': (context) => const NextPage(),
        '/home': (context) => const HomePage(),
        '/result': (context) => const ResultPage(),
      },
    );
  }
}
