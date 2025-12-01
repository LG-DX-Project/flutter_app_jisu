// lib/screens/result/result_page.dart
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          '여기는 결과 페이지',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
