// lib/screens/home/home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/result'); // 버튼 → 화면 이동
          },
          child: const Text('결과 페이지로 이동'),
        ),
      ),
    );
  }
}
