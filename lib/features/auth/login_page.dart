// lib/screens/login/login_page.dart

import 'package:flutter/material.dart';
import 'package:deaftv_lgdxschool_projects/utils/layout_utils.dart'; // 🔹

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _handleQRCodeTap() async {
    setState(() {}); // 지금은 상태 변화 없음. 나중에 로딩 표시 추가할 때 활용 가능.

    // 로딩 시뮬레이션 (0.5초 후 로딩 페이지로 이동)
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/loading');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // 🔹 공통 레이아웃 래퍼 사용
      body: buildBasePageLayout(
        context: context,
        child: buildMainPagesLayout(context), // 이 페이지 전용 UI
      ),
    );
  }

  // 첫번째 로그인 페이지 메인 레이아웃 (텍스트 + QR 코드 Row)
  Row buildMainPagesLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildTextContent()),
        const SizedBox(width: 80),
        _buildQRCodeArea(context),
      ],
    );
  }

  // 첫번째 로그인 페이지 텍스트
  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '로그인 방법을 선택하세요',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 40,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 40),
        Text(
          'ThinQ 앱으로 로그인',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 80,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 60),
        _buildInstructionText('모바일 기기에서 ThinQ앱을 실행해주세요'),
        const SizedBox(height: 20),
        _buildInstructionText('+ 버튼을 눌러 메뉴를 연 뒤 제품 추가에서 TV를 선택해주세요'),
        const SizedBox(height: 20),
        _buildInstructionText('QR 코드를 스캔해주세요'),
      ],
    );
  }

  Widget _buildInstructionText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        height: 1.2,
      ),
    );
  }

  // 첫 페이지 QR 코드 영역
  Widget _buildQRCodeArea(BuildContext context) {
    return GestureDetector(
      onTap: _handleQRCodeTap, // 클릭하면 로딩 페이지로 이동
      child: Container(
        width: 415,
        height: 416,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.qr_code_2, size: 200, color: Colors.black),
        ),
      ),
    );
  }
}
