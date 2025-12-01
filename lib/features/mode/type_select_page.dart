// lib/features/mode/mode_select_page.dart
import 'package:flutter/material.dart';
import '../../utils/layout_utils.dart';

class ModeSelectPage extends StatefulWidget {
  const ModeSelectPage({super.key});

  @override
  State<ModeSelectPage> createState() => _ModeSelectPageState();
}

class _ModeSelectPageState extends State<ModeSelectPage> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: buildBasePageLayout(
        context: context,
        child: _buildModeSelectContent(),
      ),
    );
  }

  Widget _buildModeSelectContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 제목
        _buildHeadline(),
        const SizedBox(height: 100),
        // 카드 그리드
        _buildCardGrid(),
      ],
    );
  }

  // 제목 영역
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
            height: 1.19,
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

  // 카드 2 + 3 레이아웃
  Widget _buildCardGrid() {
    //이미지 경로
    final List<Map<String, String>> modes = [
      {
        'title': '일반',
        'iconPath': 'assets/일반.png',
        'iconHoverPath': 'assets/일반-1.png',
      },
      {
        'title': '청각',
        'iconPath': 'assets/청각.png',
        'iconHoverPath': 'assets/청각-1.png',
      },
      {
        'title': '시각',
        'iconPath': 'assets/시각.png',
        'iconHoverPath': 'assets/시각-1.png',
      },
      {
        'title': '아동',
        'iconPath': 'assets/아동.png',
        'iconHoverPath': 'assets/아동-1.png',
      },
      {
        'title': '시니어',
        'iconPath': 'assets/시니어.png',
        'iconHoverPath': 'assets/시니어-1.png',
      },
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 첫 번째 줄: 2개 카드
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModeCard(
              title: modes[0]['title']!,
              iconPath: modes[0]['iconPath']!,
              iconHoverPath: modes[0]['iconHoverPath']!,
              index: 0,
            ),
            const SizedBox(width: 40),
            _buildModeCard(
              title: modes[1]['title']!, //!값이 null이 아님을 보장
              iconPath: modes[1]['iconPath']!,
              iconHoverPath: modes[1]['iconHoverPath']!,
              index: 1,
            ),
          ],
        ),
        const SizedBox(height: 40),
        // 두 번째 줄: 3개 카드
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModeCard(
              title: modes[2]['title']!,
              iconPath: modes[2]['iconPath']!,
              iconHoverPath: modes[2]['iconHoverPath']!,
              index: 2,
            ),
            const SizedBox(width: 40),
            _buildModeCard(
              title: modes[3]['title']!,
              iconPath: modes[3]['iconPath']!,
              iconHoverPath: modes[3]['iconHoverPath']!,
              index: 3,
            ),
            const SizedBox(width: 40),
            _buildModeCard(
              title: modes[4]['title']!,
              iconPath: modes[4]['iconPath']!,
              iconHoverPath: modes[4]['iconHoverPath']!,
              index: 4,
            ),
          ],
        ),
      ],
    );
  }

  // 개별 카드
  Widget _buildModeCard({
    required String title,
    required String iconPath,
    required String iconHoverPath,
    required int index,
  }) {
    final bool isHovered = _hoveredIndex == index;
    //마우스 올리면 비율이 1.2배로 커짐
    final double scale = isHovered ? 1.2 : 1.0;
    final Color borderColor = isHovered
        ? const Color(0xFFFD312E)
        : Colors.transparent;

    // hover 시 커져도 주변이 안 밀리도록 여유 공간 확보
    // hover시 최대 크기 만큼 미리 설정
    return SizedBox(
      width: 380 * 1.2,
      height: 200 * 1.2,
      child: MouseRegion(
        //마우스가 올라가는 순간 hover중임을 알림
        onEnter: (_) => setState(() => _hoveredIndex = index),
        //마우스가 떠나는 순간 hover중이 아님을 알림
        onExit: (_) => setState(() => _hoveredIndex = null),
        child: Center(
          //hover시 카드 부드럽게 커지도록 설정
          child: AnimatedScale(
            scale: scale, //1.0 -> 1.2 로 커짐
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            //박스자체 스타일 변경
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              //박스카드 크기
              width: 380,
              height: 210,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목
                    buildCardTitle(title),
                    const Spacer(),
                    // 각 카드별 이미지 영역
                    buildCardImageSection(isHovered, iconPath, iconHoverPath),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //카드 안에 이미지 표시
  Align buildCardImageSection(
    bool isHovered,
    String iconPath,
    String iconHoverPath,
  ) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 100,
        height: 100,
        child: _buildIconImage(
          isHovered: isHovered,
          iconPath: iconPath,
          iconHoverPath: iconHoverPath,
        ),
      ),
    );
  }

  //카드 안에 제목 표시
  Text buildCardTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 50,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        height: 1.19,
      ),
    );
  }

  // 이미지 위젯 (아이콘 대신 이미지 전용)
  Widget _buildIconImage({
    required bool isHovered,
    required String iconPath,
    required String iconHoverPath,
  }) {
    final String currentPath = isHovered ? iconHoverPath : iconPath;

    return Image.asset(currentPath, fit: BoxFit.contain);
  }
}
