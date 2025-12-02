// lib/features/settings/setting_page.dart
import 'package:flutter/material.dart';
import '../../utils/layout_utils.dart';

class SettingPage extends StatefulWidget {
  final Map<String, bool> toggles;

  const SettingPage({super.key, required this.toggles});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Map<String, bool> _localToggles;
  String _selectedMode = 'none';
  String _modeName = '';
  String _soundPitch = '없음';
  String _emotionColor = '없음';
  bool _isSoundPitchExpanded = false;
  bool _isEmotionColorExpanded = false;
  final Map<String, bool> _hoveredModes = {}; // 각 모드별 호버 상태

  // 🔧 레이아웃 상수
  static const double _labelWidth = 220; // 왼쪽 라벨 폭
  static const double _labelGap = 18; // 라벨 옆 공백

  // settings 섹션 안에서 "소리의 높낮이 셀 아래쪽" 위치 (패널 시작 y)
  static const double _soundPitchPanelTop =
      209; // 10(패딩) + 79(모드이름) + 40(간격) + 80(셀높이)
  static const double _soundPitchPanelLeft =
      _labelWidth + _labelGap + 80 + 20; // 220 + 18 + 80(이미지) + 20(간격) = 338

  // 감정 색상 패널 위치
  static const double _emotionColorPanelTop =
      321; // 10 + 79 + 40 + 80 + 40 + 80 - 약간 여유
  static const double _emotionColorPanelLeft =
      _labelWidth + _labelGap; // 220 + 18 = 238

  // 🔤 공통 폰트 & 스타일 상수
  static const String _fontFamily = 'Pretendard';

  static const Color _fieldBgColor = Color(0xFF333333);
  static const Color _primaryBlue = Color(0xFF3A7BFF);

  static const TextStyle _labelTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 35,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 53.2 / 38,
  );

  static const TextStyle _fieldTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 39.2 / 28,
  );

  static const TextStyle _buttonTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 39.2 / 28,
  );

  final List<Map<String, String>> _modes = const [
    {'label': '없음', 'mode': 'none'},
    {'label': '영화/드라마', 'mode': 'movie'},
    {'label': '다큐멘터리', 'mode': 'documentary'},
    {'label': '예능', 'mode': 'variety'},
  ];

  // 설정 영역 스크롤 컨트롤러 (해당 영역만 스크롤 + 스크롤바 표시용)
  final ScrollController _settingsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _localToggles = Map.from(widget.toggles);
  }

  @override
  void dispose() {
    _settingsScrollController.dispose();
    super.dispose();
  }

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

  // 소리의 높낮이에 따른 이미지 경로
  String get _soundPitchImage {
    switch (_soundPitch) {
      case '2단계':
        return 'assets/가_middle.png';
      case '3단계':
        return 'assets/가_wide.png';
      case '없음':
      case '1단계':
      default:
        return 'assets/가_basic.png';
    }
  }

  // 💡 공통 클릭 위젯 (GestureDetector + MouseRegion)
  Widget _clickable({required Widget child, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(cursor: SystemMouseCursors.click, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //기본 레이아웃 설정
      body: buildBasePageLayout(
        context: context,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 제목+부제목
              buildHeadLine(),
              const SizedBox(height: 80),
              // 모드 선택 버튼들
              Center(child: _buildModeSelector()),
              const SizedBox(height: 47),
              // 메인 컨텐츠 영역 (좌우 718px 섹션 2개, 가운데 정렬)
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 718 * 2 + 60, // 왼쪽 718 + 간격 60 + 오른쪽 718
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 왼쪽: 모드 설정 섹션 (고정 폭 718, 높이 제한)
                        SizedBox(
                          width: 718,
                          height: 500, // 스크롤 영역 높이 제한
                          child: _buildSettingsSection(),
                        ),
                        const SizedBox(width: 60),
                        // 오른쪽: 미리보기 섹션 (고정 폭 718)
                        SizedBox(
                          width: 718,
                          child: _buildRightSection(),
                        ), //미리보기
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //제목+부제목
  Column buildHeadLine() {
    return Column(
      children: const [
        Center(
          child: Text(
            '나에게 편한 자막 스타일을 골라보세요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 80,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.193,
            ),
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: Text(
            '시청 중에도 언제든 쉽게 바꿀 수 있어요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.19,
            ),
          ),
        ),
      ],
    );
  }

  // 모드 선택 버튼들
  Widget _buildModeSelector() {
    return Container(
      width: 1390,
      height: 83,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // 왼쪽 화살표
          buildArrowButton(Icons.chevron_left, onTap: () {}),
          // 모드 버튼들
          Expanded(
            child: Row(
              children: [
                // 없음 버튼 (맨 앞 고정)
                _buildModeButton('없음', 'none'),
                // 없음과 영화/드라마 사이 구분선
                const SizedBox(width: 20),
                Container(width: 1, height: 59, color: const Color(0xFF666666)),
                const SizedBox(width: 20),
                // 나머지 버튼들 (영화/드라마, 다큐멘터리, 예능)
                ..._modes.skip(1).map((modeData) {
                  return _buildModeButton(
                    modeData['label']!,
                    modeData['mode']!,
                  );
                }),
              ],
            ),
          ),
          // 오른쪽 화살표
          buildArrowButton(Icons.chevron_right, onTap: () {}),
        ],
      ),
    );
  }

  // 모드 버튼 위젯 (재사용 가능하도록 분리)
  Widget _buildModeButton(String label, String mode) {
    final isSelected = _selectedMode == mode;
    final isHovered = _hoveredModes[mode] ?? false;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _hoveredModes[mode] = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredModes[mode] = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMode = mode;
          });
        },
        child: Container(
          height: 59,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            //모드 클릭시 검정 , 기본, 호버시 F2F2F2
            color: isSelected
                ? Colors.transparent
                : (isHovered
                      ? const Color(0xFFF2F2F2)
                      : const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : null,
          ),
          //모드 텍스트 색깔 설정
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: 28,
                fontWeight: FontWeight.w500,
                //클릭시 흰색, 디폴트 검정
                color: isSelected ? Colors.white : Colors.black,
                height: 39.2 / 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //왼쪽, 오른쪽 화살표 버튼
  Widget buildArrowButton(IconData icon, {VoidCallback? onTap}) {
    return _clickable(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }

  // 설정 섹션 (피그마 Frame 폭 718 기준, 전용 스크롤바 스타일)
  Widget _buildSettingsSection() {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(const Color(0xFFBABFC4)), // 피그마 색상
        trackColor: WidgetStateProperty.all(Colors.transparent),
        radius: const Radius.circular(99),
        thickness: WidgetStateProperty.all(8),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1) 실제 스크롤 영역
          Scrollbar(
            controller: _settingsScrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _settingsScrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildModeNameField(),
                    const SizedBox(height: 40),
                    _buildSoundPitchField(), // 한 줄짜리 셀
                    const SizedBox(height: 40),
                    _buildEmotionColorField(),
                    const SizedBox(height: 40),
                    _buildToggleRow('화자 설정', '화자 설정'),
                    const SizedBox(height: 40),
                    _buildToggleRow('배경음 표시', '배경음 표시'),
                    const SizedBox(height: 40),
                    _buildToggleRow('효과음 표시', '효과음 표시'),
                  ],
                ),
              ),
            ),
          ),

          // 2) 패널 외부 클릭 시 닫기 (설정 영역 전체 덮는 투명 레이어)
          if (_isSoundPitchExpanded || _isEmotionColorExpanded)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isSoundPitchExpanded = false;
                    _isEmotionColorExpanded = false;
                  });
                },
                child: Container(color: Colors.transparent),
              ),
            ),

          // 3) 소리의 높낮이 옵션 패널 (다른 행 위로 겹쳐 표시)
          if (_isSoundPitchExpanded)
            Positioned(
              top: _soundPitchPanelTop,
              left: _soundPitchPanelLeft,
              child: _buildSoundPitchPanel(),
            ),

          // 4) 감정 색상 옵션 패널 (다른 행 위로 겹쳐 표시)
          if (_isEmotionColorExpanded)
            Positioned(
              top: _emotionColorPanelTop,
              left: _emotionColorPanelLeft,
              child: _buildEmotionColorPanel(),
            ),
        ],
      ),
    );
  }

  // 공통 설정 라벨 (왼쪽 텍스트)
  Widget _buildSettingLabel(String text, {double width = _labelWidth}) {
    return SizedBox(
      width: width,
      child: Text(text, style: _labelTextStyle),
    );
  }

  // 모드 이름 입력 필드
  Widget _buildModeNameField() {
    return Row(
      children: [
        _buildSettingLabel('모드 이름'),
        const SizedBox(width: _labelGap),
        Expanded(
          child: Container(
            height: 79,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: _fieldBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: _modeName),
                    onChanged: (value) {
                      if (value.length <= 10) {
                        setState(() {
                          _modeName = value;
                        });
                      }
                    },
                    style: _fieldTextStyle,
                    decoration: const InputDecoration(
                      hintText: '모드 이름을 적어주세요',
                      hintStyle: _fieldTextStyle,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Text(
                  '10자 이내',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 33.6 / 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 소리의 높낮이 한 줄 셀
  Widget _buildSoundPitchField() {
    return Row(
      children: [
        _buildSettingLabel('소리의 높낮이'),
        const SizedBox(width: _labelGap),
        SizedBox(
          width: 460,
          child: Row(
            children: [
              // 왼쪽 가_1 이미지 (80x80)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    _soundPitchImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.transparent,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // 오른쪽 입력 필드 (340px)
              Expanded(
                child: _clickable(
                  onTap: () {
                    setState(() {
                      _isSoundPitchExpanded = !_isSoundPitchExpanded;
                    });
                  },
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: _fieldBgColor,
                      borderRadius: _isSoundPitchExpanded
                          ? const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.zero,
                            )
                          : BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_soundPitch, style: _fieldTextStyle),
                        Icon(
                          _isSoundPitchExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 소리의 높낮이 옵션 전체 패널
  Widget _buildSoundPitchPanel() {
    return Material(
      elevation: 8,
      color: Colors.transparent,
      child: Container(
        width: 340, // 입력 필드 너비 (460 - 80 - 20)
        decoration: BoxDecoration(
          color: _fieldBgColor,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSoundPitchOption('없음'),
            _buildSoundPitchOption('1단계'),
            _buildSoundPitchOption('2단계'),
            _buildSoundPitchOption('3단계'),
          ],
        ),
      ),
    );
  }

  // 소리의 높낮이 옵션 한 줄
  Widget _buildSoundPitchOption(String label) {
    final bool isSelected = _soundPitch == label;
    return _clickable(
      onTap: () {
        setState(() {
          _soundPitch = label;
          _isSoundPitchExpanded = false;
        });
      },
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.15)
              : Colors.transparent,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(label, style: _fieldTextStyle),
        ),
      ),
    );
  }

  // 감정 색상 한 줄 셀
  Widget _buildEmotionColorField() {
    return Row(
      children: [
        _buildSettingLabel('감정 색상'),
        const SizedBox(width: _labelGap),
        SizedBox(
          width: 460, // 소리의 높낮이와 동일한 너비
          child: _clickable(
            onTap: () {
              setState(() {
                _isEmotionColorExpanded = !_isEmotionColorExpanded;
              });
            },
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: _fieldBgColor,
                borderRadius: _isEmotionColorExpanded
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero,
                      )
                    : BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_emotionColor, style: _fieldTextStyle),
                  Icon(
                    _isEmotionColorExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 감정 색상 옵션 전체 패널
  Widget _buildEmotionColorPanel() {
    return Material(
      elevation: 8,
      color: Colors.transparent,
      child: Container(
        width: 460, // 소리의 높낮이와 동일한 전체 너비
        decoration: BoxDecoration(
          color: _fieldBgColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEmotionColorOption('없음', null, false),
            _buildEmotionColorOption('1단계', _getColorPalette(1), false),
            _buildEmotionColorOption('2단계', _getColorPalette(2), true),
            _buildEmotionColorOption('3단계', _getColorPalette(3), false),
          ],
        ),
      ),
    );
  }

  // 감정 색상 옵션 한 줄
  Widget _buildEmotionColorOption(
    String label,
    List<Color>? colorPalette,
    bool showRecommended,
  ) {
    final bool isSelected = _emotionColor == label;

    return _clickable(
      onTap: () {
        setState(() {
          _emotionColor = label;
          _isEmotionColorExpanded = false;
        });
      },
      child: Container(
        height: 79,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.15)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Text(label, style: _fieldTextStyle),
            if (colorPalette != null) ...[
              const SizedBox(width: 14),
              Row(
                children: colorPalette
                    .map(
                      (color) => Container(
                        width: 30,
                        height: 38,
                        margin: const EdgeInsets.only(right: 1),
                        color: color,
                      ),
                    )
                    .toList(),
              ),
            ],
            if (showRecommended) ...[
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Text(
                    '권장',
                    style: TextStyle(
                      fontFamily: _fontFamily,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 33.6 / 24,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 색상 팔레트 반환 (단계별)
  List<Color> _getColorPalette(int level) {
    switch (level) {
      case 1:
        return [
          const Color(0xFFFF8A80), // 빨강
          const Color(0xFFFFD54F), // 노랑
          const Color(0xFFFFE082), // 연노랑
          const Color(0xFFA5D6A7), // 연초록
          const Color(0xFF90CAF9), // 연파랑
          const Color(0xFFCE93D8), // 연보라
          const Color(0xFFE0E0E0), // 회색
        ];
      case 2:
        return [
          const Color(0xFFFF6F6F), // 빨강
          const Color(0xFFFFB800), // 주황
          const Color(0xFFFFD54F), // 노랑
          const Color(0xFF81C784), // 초록
          const Color(0xFF64B5F6), // 파랑
          const Color(0xFFBA68C8), // 보라
          const Color(0xFFE0E0E0), // 회색
        ];
      case 3:
        return [
          const Color(0xFFFF5252), // 진빨강
          const Color(0xFFFFA000), // 진주황
          const Color(0xFFFFCA28), // 진노랑
          const Color(0xFF66BB6A), // 진초록
          const Color(0xFF42A5F5), // 진파랑
          const Color(0xFFAB47BC), // 진보라
          const Color(0xFFE0E0E0), // 회색
        ];
      default:
        return [];
    }
  }

  // 토글 행
  Widget _buildToggleRow(String label, String toggleKey) {
    final bool value = _localToggles[toggleKey] ?? false;
    return Row(
      children: [
        _buildSettingLabel(label, width: 200),
        const SizedBox(width: 40),
        Switch(
          value: value,
          onChanged: (v) {
            setState(() {
              _localToggles[toggleKey] = v;
            });
          },
          activeThumbColor: _primaryBlue,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFF4A4A4A),
        ),
      ],
    );
  }

  // 오른쪽 섹션 (미리보기 + 버튼들)
  Widget _buildRightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '미리보기',
          style: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 38,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            height: 53.2 / 38,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 560,
          height: 315,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(2.8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.8),
            child: Stack(
              children: [
                Image.asset(
                  _previewImage,
                  width: 560,
                  height: 315,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.image, size: 60)),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 56,
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: Text(
                        '자막 스타일이 이렇게 보여요!',
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 25.2,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 30.07 / 25.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: 560,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 추가하기 버튼 (영화/드라마, 다큐멘터리, 예능 선택 시 비활성화)
              _buildAddButton(
                191,
                60,
                _selectedMode == 'none'
                    ? () {
                        // TODO: 추가하기 동작
                      }
                    : null,
              ),
              const SizedBox(width: 24),
              _buildApplyButton(
                text: '적용하기',
                width: 191,
                height: 60,
                onTap: () {
                  Navigator.pop(context, _localToggles);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 추가하기 버튼 (어두운 배경 + 파란색 테두리 + 플러스 아이콘)
  Widget _buildAddButton(double width, double height, VoidCallback? onTap) {
    final bool isDisabled = onTap == null;

    return Opacity(
      opacity: isDisabled ? 0.0 : 1.0, // 비활성화 시 완전 투명
      child: _clickable(
        onTap: isDisabled ? null : onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF141311), // 어두운 회색 배경
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _primaryBlue, // 파란색 테두리
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.add, color: _primaryBlue, size: 32),
              ),
              SizedBox(width: 10),
              Text(
                '추가하기',
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: _primaryBlue,
                  height: 39.2 / 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 적용하기 버튼 (체크 아이콘 + 텍스트)
  Widget _buildApplyButton({
    required String text,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    return _clickable(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: _primaryBlue, // 단색 파랑
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.check, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 10),
            Text(text, style: _buttonTextStyle),
          ],
        ),
      ),
    );
  }
}
