// lib/features/screens/home/home_page.dart
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isPanelVisible = false;
  String _selectedMode = 'none';

  // 🔥 모드 버튼 목록 (고정 순서)
  final List<Map<String, String>> _modes = const [
    {'label': '없음', 'mode': 'none'},
    {'label': '영화/드라마', 'mode': 'movie'},
    {'label': '다큐멘터리', 'mode': 'documentary'},
    {'label': '예능', 'mode': 'variety'},
  ];

  // 🔥 모드 리스트 스크롤 컨트롤러
  final ScrollController _modeScrollController = ScrollController();

  // 🔥 토글 상태 Map
  final Map<String, bool> _toggles = {
    '소리의 높낮이': true,
    '감정 색상': false,
    '화자 설정': false,
    '배경음 표시': false,
    '효과음 표시': true,
  };

  // 미리보기 이미지
  String get _previewImage {
    switch (_selectedMode) {
      case 'movie':
        return 'assets/preview_movie.png';
      case 'documentary':
        return 'assets/preview_documentary.png';
      case 'variety':
        return 'assets/preview_variety.png';
      case 'none':
      default:
        return 'assets/preview_none.png';
    }
  }

  @override
  void dispose() {
    _modeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 배경 이미지
          SizedBox.expand(
            child: Image.asset(
              'assets/home_background.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.black),
            ),
          ),

          // 왼쪽 hover-zone (패널이 닫혀 있을 때만 활성)
          if (!_isPanelVisible)
            Positioned(
              left: 0,
              top: 0,
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height,
              child: MouseRegion(
                onEnter: (_) => setState(() => _isPanelVisible = true),
                child: Container(color: Colors.transparent),
              ),
            ),

          // 슬라이드 패널
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _isPanelVisible ? 0 : -555,
            top: 0,
            bottom: 0,
            child: MouseRegion(
              onExit: (_) => setState(() => _isPanelVisible = false),
              child: _buildSidePanel(),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔹 왼쪽 슬라이드 패널 (세로 스크롤 제거, 고정 레이아웃)
  // ---------------------------------------------------------
  Widget _buildSidePanel() {
    return Container(
      width: 555,
      decoration: BoxDecoration(
        color: const Color(0xFF222222).withOpacity(0.92),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 28,
          top: 40,
          right: 28,
          bottom: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddButton(),
            const SizedBox(height: 40),
            _buildModeButtons(),
            const SizedBox(height: 40),
            _buildPreviewSection(),
            const SizedBox(height: 40),
            _buildSettingsSection(),
            const SizedBox(height: 32),
            _buildToggleSwitches(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // 버튼: 추가하기
  // ---------------------------------------------------------
  Widget _buildAddButton() {
    return Container(
      width: 160,
      height: 59,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF315BD5), Color(0xFF9232DD)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          '추가하기',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // 버튼 그룹: 없음 / 영화 / 다큐 / 예능 (가로 스크롤)
  // ---------------------------------------------------------
  Widget _buildModeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 왼쪽 화살표
        SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            Icons.chevron_left,
            color: Colors.white.withOpacity(0.8),
            size: 32,
          ),
        ),

        // 🔥 가로 스크롤 가능한 버튼 영역 (피그마: width 419, height 67)
        Container(
          width: 419, // 피그마 기준 고정 너비
          height: 67, // 피그마 기준 고정 높이
          padding: const EdgeInsets.all(4), // 박스 앞 패딩: 4
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _modeScrollController,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: List.generate(_modes.length, (index) {
                  final modeData = _modes[index];
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (index > 0)
                        const SizedBox(width: 20), // 박스와 박스 사이 거리: 20
                      _buildModeButton(
                        label: modeData['label']!,
                        mode: modeData['mode']!,
                        index: index,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),

        // 오른쪽 화살표
        SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            Icons.chevron_right,
            color: Colors.white.withOpacity(0.8),
            size: 32,
          ),
        ),
      ],
    );
  }

  Widget _buildModeButton({
    required String label,
    required String mode,
    required int index,
  }) {
    final bool isSelected = _selectedMode == mode;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMode = mode;
        });

        // 🔥 선택된 버튼이 앞으로 "밀려오는" 느낌으로 스크롤 이동
        // 버튼 하나의 대략적인 폭: (minWidth 72 + 가로패딩 24*2) + 간격 20 ≈ 140
        const double itemWidth = 140;
        final double targetOffset =
            (index * itemWidth) - itemWidth; // 선택된 버튼이 살짝 왼쪽으로 당겨지게
        final double maxOffset = _modeScrollController.position.maxScrollExtent;

        _modeScrollController.animateTo(
          targetOffset.clamp(0, maxOffset),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      },
      child: Container(
        height: 59,
        constraints: const BoxConstraints(minWidth: 72),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: const Color(0xFF9033DD), width: 1)
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 39.2 / 28,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // 미리보기 이미지
  // ---------------------------------------------------------
  Widget _buildPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '미리보기',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 400,
          height: 225,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Stack(
              children: [
                Image.asset(
                  _previewImage,
                  width: 400,
                  height: 225,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.image, size: 60)),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: Text(
                        '자막 스타일이 이렇게 보여요!',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // 설정 / 세부설정 버튼들
  // ---------------------------------------------------------
  Widget _buildSettingsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 120,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(73),
          ),
          child: const Center(
            child: Text(
              '설정',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(46),
          ),
          child: const Text(
            '세부설정',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // 🔥 토글 리스트 (실제로 on/off 동작)
  // ---------------------------------------------------------
  Widget _buildToggleSwitches() {
    return Column(
      children: _toggles.keys.map((label) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _buildToggleItem(label),
        );
      }).toList(),
    );
  }

  Widget _buildToggleItem(String label) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          Switch(
            value: _toggles[label]!,
            onChanged: (v) {
              setState(() => _toggles[label] = v);
            },
            activeColor: const Color(0xFF0A9B02),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFF7F7F7F),
          ),
        ],
      ),
    );
  }
}
