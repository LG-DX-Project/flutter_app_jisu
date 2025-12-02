// lib/features/screens/home/home_page.dart
import 'package:flutter/material.dart';
import '../../settings/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isPanelVisible = false;
  String _selectedMode = 'none';
  bool _isDetailSettingsHovered = false; // 세부설정 호버 상태

  // 모드 버튼 목록 (고정 순서)
  final List<Map<String, String>> _modes = const [
    {'label': '없음', 'mode': 'none'},
    {'label': '영화/드라마', 'mode': 'movie'},
    {'label': '다큐멘터리', 'mode': 'documentary'},
    {'label': '예능', 'mode': 'variety'},
  ];

  // 모드 리스트 스크롤 컨트롤러
  final ScrollController _modeScrollController = ScrollController();

  // 토글 상태 Map
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

          // 슬라이드 패널 (왼쪽/위/아래 30px 띄우기)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _isPanelVisible ? 30 : -555,
            top: 30,
            bottom: 30,
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
  // 왼쪽 슬라이드 패널
  // ---------------------------------------------------------
  Widget _buildSidePanel() {
    return Container(
      width: 555,
      decoration: BoxDecoration(
        color: const Color(0xFF222222).withOpacity(0.92),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.zero, // 화면 모서리와 맞닿는 부분
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
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
  // 퀵모드 섹션 (이미지 + 텍스트 + 화살표 아이콘)
  // ---------------------------------------------------------
  Widget _buildAddButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 왼쪽: 이미지 + 텍스트
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 왼쪽 이미지
            Image.asset(
              'assets/quick_image.png',
              width: 48,
              height: 48,
              errorBuilder: (context, error, stackTrace) {
                return Container(width: 48, height: 48, color: Colors.grey);
              },
            ),
            const SizedBox(width: 16),
            // "퀵모드" 텍스트
            const Text(
              '퀵모드',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 44.8 / 32,
              ),
            ),
          ],
        ),
        // 오른쪽: 화살표 아이콘 (클릭 시 패널 닫기)
        GestureDetector(
          onTap: () {
            setState(() {
              _isPanelVisible = false;
            });
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // 모드 버튼 그룹 (없음 / 영화 / 다큐 / 예능)
  // ---------------------------------------------------------
  Widget _buildModeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 왼쪽 화살표
        GestureDetector(
          onTap: () {
            if (_modeScrollController.hasClients) {
              // 한 버튼 너비만큼 왼쪽으로 스크롤
              final scrollAmount = _calculateButtonWidth();
              final newOffset = (_modeScrollController.offset - scrollAmount)
                  .clamp(0.0, _modeScrollController.position.maxScrollExtent)
                  .toDouble();
              _modeScrollController.animateTo(
                newOffset,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.chevron_left, color: Colors.white70, size: 32),
            ),
          ),
        ),

        // 가로 스크롤 영역
        Container(
          width: 419,
          height: 67,
          padding: const EdgeInsets.all(4),
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
                      if (index > 0) const SizedBox(width: 20),
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
        GestureDetector(
          onTap: () {
            if (_modeScrollController.hasClients) {
              // 한 버튼 너비만큼 오른쪽으로 스크롤
              final scrollAmount = _calculateButtonWidth();
              final newOffset = (_modeScrollController.offset + scrollAmount)
                  .clamp(0.0, _modeScrollController.position.maxScrollExtent)
                  .toDouble();
              _modeScrollController.animateTo(
                newOffset,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.chevron_right, color: Colors.white70, size: 32),
            ),
          ),
        ),
      ],
    );
  }

  // 버튼의 평균 너비 계산 (스크롤 이동량 결정용)
  double _calculateButtonWidth() {
    double totalWidth = 0;
    for (final modeData in _modes) {
      final label = modeData['label']!;
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      totalWidth += textPainter.size.width + 48; // padding 24*2
    }
    // 평균 버튼 너비 + 간격
    return (totalWidth / _modes.length) + 20;
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

        // 다음 프레임에서 버튼 위치 계산 및 스크롤 이동
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_modeScrollController.hasClients) {
            // 이전 버튼들의 누적 너비 계산 (간격 포함)
            double cumulativeWidth = 0;
            for (int i = 0; i < index; i++) {
              // 각 버튼의 예상 너비 계산 (텍스트 길이 기반)
              final prevLabel = _modes[i]['label']!;
              final textPainter = TextPainter(
                text: TextSpan(
                  text: prevLabel,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                textDirection: TextDirection.ltr,
              );
              textPainter.layout();
              final prevButtonWidth =
                  textPainter.size.width + 48; // padding 24*2
              cumulativeWidth += prevButtonWidth + (i > 0 ? 20 : 0); // 간격 20px
            }

            // 버튼을 맨 앞으로 보이도록 스크롤
            _modeScrollController.animateTo(
              cumulativeWidth.clamp(
                0,
                _modeScrollController.position.maxScrollExtent,
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      },
      child: Container(
        height: 59,
        constraints: const BoxConstraints(minWidth: 72),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Color(0xFF4A4A4A),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(
                  color: Colors.white, // 흰색 테두리
                  width: 3,
                )
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 39.2 / 28,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // 미리보기 섹션
  // ---------------------------------------------------------
  Widget _buildPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(
          child: Text(
            '미리보기',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Container(
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
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // 설정 / 세부설정
  // ---------------------------------------------------------
  Widget _buildSettingsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 왼쪽: 아이콘 + 텍스트
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 설정 아이콘 (48x48 원형)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image(image: AssetImage('assets/settings_image.png')),
                ),
              ),
            ),
            const SizedBox(width: 13),
            // "설정" 텍스트
            const Text(
              '설정',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 44.8 / 32,
              ),
            ),
          ],
        ),
        _buildDetailSettingsButton(),
      ],
    );
  }

  // 세부설정 버튼 (텍스트 + 아이콘 중앙정렬, 호버 시 테두리)
  Widget _buildDetailSettingsButton() {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push<Map<String, bool>>(
          context,
          MaterialPageRoute(
            builder: (_) => SettingPage(toggles: Map.from(_toggles)),
          ),
        );

        if (result != null) {
          setState(() {
            _toggles
              ..clear()
              ..addAll(result);
          });
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isDetailSettingsHovered = true),
        onExit: (_) => setState(() => _isDetailSettingsHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48, // 버튼 높이 고정
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(46),
            border: _isDetailSettingsHovered
                ? Border.all(color: Colors.white, width: 1)
                : null,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  '세부설정',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 39.2 / 28,
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // 토글 리스트
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
            activeThumbColor: const Color(0xFF3A7BFF),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFF4A4A4A),
          ),
        ],
      ),
    );
  }
}
