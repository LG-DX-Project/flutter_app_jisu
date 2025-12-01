// lib/features/auth/login_select_page.dart
import 'package:flutter/material.dart';
import '../../utils/layout_utils.dart';

class LoginSelectPage extends StatefulWidget {
  const LoginSelectPage({super.key});

  @override
  State<LoginSelectPage> createState() => _LoginSelectPageState();
}

class _LoginSelectPageState extends State<LoginSelectPage> {
  @override
  void initState() {
    super.initState();
    // ✅ 3초 후 자동으로 모드 선택 페이지로 이동 (네 번째 화면)
    //    클릭 요소 없이 로딩처럼 사용
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/mode-select');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: buildBasePageLayout(
        context: context,
        child: _buildLoginSelectContent(),
      ),
    );
  }

  /// 전체 화면 내용 (텍스트 + 계정 카드)
  Widget _buildLoginSelectContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ✅ 계정 카드 전체를 화면 가로 중앙에 배치
        Center(child: _buildAccountCard()),
      ],
    );
  }

  /// 계정 선택 카드 UI
  /// 시각적으로 가운데 오도록 Stack + Align 사용
  Widget _buildAccountCard() {
    return SizedBox(
      width: 517,
      height: 395,
      child: Stack(
        // alignment를 기본 center로 깔아두면,
        // Align에서 topCenter / bottomCenter 기준이 더 직관적임
        alignment: Alignment.center,
        children: [
          // ✅ 파란색 원형 프레임 (L 아이콘) - 상단 중앙 배치
          Align(alignment: Alignment.topCenter, child: buildLgIdImage()),

          // ✅ 반투명 흰색 프레임 (이메일) - 하단 중앙 배치
          Align(
            alignment: Alignment.bottomCenter,
            //로그인 했을 때 뜨는 로그인 아이디.
            child: buildLgLoginId(),
          ),
        ],
      ),
    );
  }

  //로그인 했을 때 뜨는 로그인 아이디. 반투명 흰색 프레임 (이메일) - 하단 중앙 배치
  Container buildLgLoginId() {
    return Container(
      width: 517,
      height: 75,
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.2), // opacity: 0.2
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Center(
        child: Text(
          'Lgdxschool3@gmail.com',
          style: TextStyle(
            fontFamily: 'LG Smart_H',
            fontSize: 40,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.085,
          ),
        ),
      ),
    );
  }

  // ✅ 파란색 원형 프레임 (L 아이콘) - 상단 중앙 배치
  Container buildLgIdImage() {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        color: const Color(0xFF505dff), // #505dff
        borderRadius: BorderRadius.circular(160),
      ),
      child: const Center(
        child: Text(
          'L',
          style: TextStyle(
            fontFamily: 'LG Smart_H',
            fontSize: 133.33,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.08,
          ),
        ),
      ),
    );
  }
}
