// lib/features/mode/mode_select_page.dart
import 'package:flutter/material.dart';
import '../../utils/layout_utils.dart';
import '../screens/home/home_page.dart';

class ModeSelectPage extends StatefulWidget {
  const ModeSelectPage({super.key});

  @override
  State<ModeSelectPage> createState() => _ModeSelectPageState();
}

class _ModeSelectPageState extends State<ModeSelectPage> {
  String? _selectedMode; // 선택된 모드

  // 모드 목록 (순서 고정)
  final List<Map<String, String>> _modes = const [
    {'label': '없음', 'mode': 'none'},
    {'label': '영화/드라마', 'mode': 'movie'},
    {'label': '다큐멘터리', 'mode': 'documentary'},
    {'label': '예능', 'mode': 'variety'},
  ];

  // 모드별 영상/이미지 경로 매핑
  // 나중에 동영상 경로로 변경 가능
  String? _getVideoPathForMode(String? mode) {
    switch (mode) {
      case 'none':
        return 'assets/mode_none.png'; // 없음 모드용 영상/이미지
      case 'movie':
        return 'assets/mode_movie.png'; // 영화/드라마 모드용 영상/이미지
      case 'documentary':
        return 'assets/mode_documentary.png'; // 다큐멘터리 모드용 영상/이미지
      case 'variety':
        return 'assets/mode_variety.png'; // 예능 모드용 영상/이미지
      default:
        return null; // 선택되지 않았을 때
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: buildBasePageLayout(context: context, child: _buildContent()),
    );
  }

  //전체 컨텐츠 레이아웃
  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeadline(), // 🔥 통일된 메인 제목
          const SizedBox(height: 48),
          //버튼 컨테이너 영역
          _buildButtonContainer(),
          const SizedBox(height: 48),
          //영상 영역
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
  // 버튼 컨테이너 (Segmented Control 스타일)
  Widget _buildButtonContainer() {
    // 선택된 버튼의 인덱스 찾기
    int selectedIndex = -1;
    if (_selectedMode != null) {
      for (int i = 0; i < _modes.length; i++) {
        if (_modes[i]['mode'] == _selectedMode) {
          selectedIndex = i;
          break;
        }
      }
    }

    // 컨테이너 크기 계산 (버튼 4개 + 간격 3개 + 패딩)
    const double buttonWidth = 250.0;
    const double buttonGap = 8.0;
    const double padding = 8.0;
    final double containerWidth =
        (buttonWidth * _modes.length) +
        (buttonGap * (_modes.length - 1)) +
        (padding * 2);

    return Center(
      child: Container(
        width: containerWidth,
        padding: const EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 버튼들
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(_modes.length, (index) {
                final modeData = _modes[index];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (index > 0) const SizedBox(width: buttonGap),
                    _buildModeButton(
                      label: modeData['label']!,
                      mode: modeData['mode']!,
                      isSelected: _selectedMode == modeData['mode'],
                    ),
                  ],
                );
              }),
            ),
            // 하이라이트 스트로크 (선택된 버튼 위치로 이동)
            if (selectedIndex >= 0) _buildHighlightStroke(selectedIndex),
          ],
        ),
      ),
    );
  }

  // 하이라이트 스트로크 위젯
  Widget _buildHighlightStroke(int selectedIndex) {
    // 버튼 너비와 간격
    const double buttonWidth = 250.0;
    const double buttonGap = 8.0;
    const double padding = 8.0;

    // 선택된 버튼의 left 위치 계산
    double left = padding;
    for (int i = 0; i < selectedIndex; i++) {
      left += buttonWidth + buttonGap;
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      left: left,
      top: padding,
      child: Container(
        width: buttonWidth,
        height: 59,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1),
        ),
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
          // border는 하이라이트 스트로크로 처리하므로 제거
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.4, // lineHeight: 39.2px / fontSize: 28px ≈ 1.4
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
  // 모드에 따라 다른 영상/이미지 표시
  Widget _buildVideoArea() {
    final videoPath = _getVideoPathForMode(_selectedMode);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // 모드별 토글 상태 설정
          Map<String, bool>? initialToggles;
          if (_selectedMode == 'movie') {
            // 영화/드라마 모드: 모든 토글 on
            initialToggles = {
              '소리의 높낮이': true,
              '감정 색상': true,
              '화자 설정': true,
              '배경음 표시': true,
              '효과음 표시': true,
            };
          }

          // 영화/드라마 모드와 예능 모드일 때 소리의 높낮이와 감정 ㅡ 2단계로 설정
          String? initialSoundPitch;
          String? initialEmotionColor;
          if (_selectedMode == 'movie' || _selectedMode == 'variety') {
            initialSoundPitch = '2단계';
            initialEmotionColor = '2단계';
          } else if (_selectedMode == 'documentary') {
            // 다큐멘터리 모드: 배경음, 효과음 on / 나머지 off
            initialToggles = {
              '소리의 높낮이': false,
              '감정 색상': false,
              '화자 설정': false,
              '배경음 표시': true,
              '효과음 표시': true,
            };
          } else if (_selectedMode == 'variety') {
            // 예능 모드: 소리의 높낮이, 감정 색상, 배경음 on / 화자 설정, 효과음 off
            initialToggles = {
              '소리의 높낮이': true,
              '감정 색상': true,
              '화자 설정': false,
              '배경음 표시': true,
              '효과음 표시': false,
            };
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                initialToggles: initialToggles,
                initialMode: _selectedMode,
                initialSoundPitch: initialSoundPitch,
                initialEmotionColor: initialEmotionColor,
              ),
            ),
          );
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
            child: videoPath != null
                ? Image.asset(
                    videoPath,
                    width: 800,
                    height: 500,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                  )
                : _buildPlaceholder(),
          ),
        ),
      ),
    );
  }

  // 플레이스홀더 (선택되지 않았거나 영상을 찾을 수 없을 때)
  Widget _buildPlaceholder() {
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
              _selectedMode == null ? '시청 유형을 선택해주세요' : '영상 영역',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _selectedMode == null
                  ? '위에서 시청 유형을 선택하면 영상이 표시됩니다'
                  : '클릭하여 홈으로 이동',
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
  }
}
