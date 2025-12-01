// lib/features/mode/mode_select_page.dart
import 'package:flutter/material.dart';
import '../../utils/layout_utils.dart';

class ModeSelectPage extends StatefulWidget {
  const ModeSelectPage({super.key});

  @override
  State<ModeSelectPage> createState() => _ModeSelectPageState();
}

class _ModeSelectPageState extends State<ModeSelectPage> {
  String? _selectedMode; // 선택된 모드

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: buildBasePageLayout(context: context, child: _buildContent()),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeadline(), // 🔥 통일된 제목
          const SizedBox(height: 48),
          _buildButtonContainer(),
          const SizedBox(height: 48),
          _buildVideoArea(),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 통일된 제목 스타일 (Headline)
  Widget _buildHeadline() {
    return Column(
      children: [
        Text(
          '시청 유형을 선택해주세요',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 80,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.193, // ★ 통일
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          '더 편안한 시청 경험을 위해, 나에게 맞는 시청 유형을 선택해주세요',
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.19,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // 버튼 컨테이너
  Widget _buildButtonContainer() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildModeButton(
            label: '없음',
            mode: 'none',
            isSelected: _selectedMode == 'none',
          ),
          const SizedBox(width: 5),
          _buildModeButton(
            label: '영화/드라마',
            mode: 'movie',
            isSelected: _selectedMode == 'movie',
          ),
          const SizedBox(width: 5),
          _buildModeButton(
            label: '다큐멘터리',
            mode: 'documentary',
            isSelected: _selectedMode == 'documentary',
          ),
          const SizedBox(width: 5),
          _buildModeButton(
            label: '예능',
            mode: 'variety',
            isSelected: _selectedMode == 'variety',
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 개별 버튼 UI
  Widget _buildModeButton({
    required String label,
    required String mode,
    required bool isSelected,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMode = isSelected ? null : mode;
          });
        },
        child: Container(
          width: 250,
          height: 59,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: Colors.white, width: 1)
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.19,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 영상 영역
  // -------------------------------------------------------------
  Widget _buildVideoArea() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/home');
        },
        child: Container(
          width: 800,
          height: 500,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/screenshot_2025-11-30_11.16.03_1.png',
              width: 800,
              height: 500,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 800,
                  height: 500,
                  color: const Color(0xFFD9D9D9),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          size: 120,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '영상 영역',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '클릭하여 홈으로 이동',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
