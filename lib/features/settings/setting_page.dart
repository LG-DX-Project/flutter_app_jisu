// lib/features/settings/setting_page.dart
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final Map<String, bool> toggles;
  final String? initialSoundPitch;
  final String? initialEmotionColor;

  const SettingPage({
    super.key,
    required this.toggles,
    this.initialSoundPitch,
    this.initialEmotionColor,
  });

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
  bool _isApplyHovered = false; // 적용하기 버튼 호버 상태
  bool _isAddHovered = false; // 추가하기 버튼 호버 상태

  // 초기값 저장 (변경 감지용)
  String _initialModeName = '';
  String _initialSoundPitch = '없음';
  String _initialEmotionColor = '없음';
  Map<String, bool> _initialToggles = {};

  // 커스텀 모드 목록 (동적으로 추가됨)
  final List<Map<String, dynamic>> _customModes = [];

  // ============================================================================
  // 레이아웃 상수
  // ============================================================================

  /// 왼쪽 라벨 폭
  static const double _labelWidth = 220;

  /// 라벨과 입력 필드 사이 간격
  static const double _labelGap = 18;

  /// 모드 선택 컨테이너 너비
  static const double _modeSelectorWidth = 1390;

  /// 모드 선택 컨테이너 높이
  static const double _modeSelectorHeight = 83;

  /// 모드 버튼 높이
  static const double _modeButtonHeight = 59;

  /// 모드 버튼 간격
  static const double _modeButtonSpacing = 20;

  /// 설정 섹션 너비
  static const double _settingsSectionWidth = 718;

  /// 설정 섹션 높이
  static const double _settingsSectionHeight = 500;

  /// 섹션 간 간격
  static const double _sectionGap = 60;

  /// 소리의 높낮이 필드 너비
  static const double _soundPitchFieldWidth = 460;

  /// 소리의 높낮이 이미지 크기
  static const double _soundPitchImageSize = 80;

  /// 소리의 높낮이 패널 너비 (입력 필드 너비 - 이미지 - 간격)
  static const double _soundPitchPanelWidth = 340;

  /// 감정 색상 필드 너비
  static const double _emotionColorFieldWidth = 460;

  /// 미리보기 영역 너비
  static const double _previewWidth = 560;

  /// 미리보기 영역 높이
  static const double _previewHeight = 315;

  /// 버튼 너비
  static const double _buttonWidth = 191;

  /// 버튼 높이
  static const double _buttonHeight = 60;

  /// 버튼 간 간격
  static const double _buttonSpacing = 24;

  /// 입력 필드 높이
  static const double _inputFieldHeight = 79;

  /// 드롭다운 필드 높이
  static const double _dropdownFieldHeight = 80;

  /// 필드 간 간격
  static const double _fieldSpacing = 40;

  /// 패널 옵션 높이
  static const double _panelOptionHeight = 80;

  /// 감정 색상 옵션 높이
  static const double _emotionColorOptionHeight = 79;

  /// 색상 팔레트 박스 너비 (패널 내)
  static const double _colorPaletteBoxWidth = 30;

  /// 색상 팔레트 박스 높이 (패널 내)
  static const double _colorPaletteBoxHeight = 38;

  /// 색상 팔레트 박스 너비 (필드 미리보기)
  static const double _colorPalettePreviewWidth = 18;

  /// 색상 팔레트 박스 높이 (필드 미리보기)
  static const double _colorPalettePreviewHeight = 26;

  /// settings 섹션 안에서 "소리의 높낮이 셀 아래쪽" 위치 (패널 시작 y)
  /// 계산: 10(패딩) + 79(모드이름) + 40(간격) + 80(셀높이)
  static const double _soundPitchPanelTop = 209;

  /// 소리의 높낮이 패널 왼쪽 위치
  /// 계산: 라벨 너비 + 라벨 간격 + 이미지 크기 + 간격 = 220 + 18 + 80 + 20
  static const double _soundPitchPanelLeft = 338;

  /// 감정 색상 패널 위치 (y)
  /// 계산: 10 + 79 + 40 + 80 + 40 + 80 - 약간 여유
  static const double _emotionColorPanelTop = 321;

  /// 감정 색상 패널 왼쪽 위치
  /// 계산: 라벨 너비 + 라벨 간격 = 220 + 18
  static const double _emotionColorPanelLeft = 238;

  // ============================================================================
  // 색상 상수
  // ============================================================================

  /// 폰트 패밀리
  static const String _fontFamily = 'Pretendard';

  /// 입력 필드 배경색
  static const Color _fieldBgColor = Color(0xFF333333);

  /// 메인 파란색 (버튼, 테두리 등)
  static const Color _primaryBlue = Color(0xFF3A7BFF);

  /// 적용하기 버튼 호버 색상
  static const Color _applyButtonHoverColor = Color(0xff6698FF);

  /// 추가/삭제 버튼 배경색 (기본)
  static const Color _addDeleteButtonBgColor = Color(0xFF141311);

  /// 추가/삭제 버튼 배경색 (호버)
  static const Color _addDeleteButtonHoverBgColor = Color(0xFF37342F);

  /// 모드 선택 컨테이너 배경색
  static const Color _modeSelectorBgColor = Color(0xFF333333);

  /// 구분선 색상
  static const Color _separatorColor = Color(0xFF666666);

  /// 기본 모드 버튼 배경색
  static const Color _defaultModeButtonBgColor = Color(0xFFE0E0E0);

  /// 기본 모드 버튼 호버 배경색
  static const Color _defaultModeButtonHoverBgColor = Color(0xFFF2F2F2);

  /// 커스텀 모드 버튼 배경색 (노란색)
  static const Color _customModeButtonBgColor = Color(0xFFFFD54F);

  /// 커스텀 모드 버튼 호버 배경색 (주황색)
  static const Color _customModeButtonHoverBgColor = Color(0xFFFFB800);

  /// 스크롤바 색상
  static const Color _scrollbarColor = Color(0xFFBABFC4);

  /// 토글 비활성 트랙 색상
  static const Color _toggleInactiveTrackColor = Color(0xFF4A4A4A);

  /// 미리보기 배경색
  static const Color _previewBgColor = Color(0xFFD9D9D9);

  /// 선택된 옵션 배경색 (투명도)
  static const double _selectedOptionBgOpacity = 0.15;

  /// 패널 그림자 투명도
  static const double _panelShadowOpacity = 0.3;

  /// 비활성화된 필드 투명도
  static const double _disabledFieldOpacity = 0.5;

  // ============================================================================
  // 텍스트 스타일 상수
  // ============================================================================

  /// 라벨 텍스트 스타일 (왼쪽 라벨용)
  static const TextStyle _labelTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 35,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 53.2 / 38,
  );

  /// 입력 필드 텍스트 스타일
  static const TextStyle _fieldTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 39.2 / 28,
  );

  /// 버튼 텍스트 스타일
  static const TextStyle _buttonTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 39.2 / 28,
  );

  /// 모드 버튼 텍스트 스타일
  static const TextStyle _modeButtonTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 39.2 / 28,
  );

  /// 모드 이름 필드 힌트/카운터 텍스트 스타일
  static const TextStyle _modeNameCounterTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 33.6 / 24,
  );

  /// 권장 배지 텍스트 스타일
  static const TextStyle _recommendedBadgeTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    height: 33.6 / 24,
  );

  /// 미리보기 제목 텍스트 스타일
  static const TextStyle _previewTitleTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 38,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 53.2 / 38,
  );

  /// 미리보기 하단 텍스트 스타일
  static const TextStyle _previewBottomTextStyle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 25.2,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 30.07 / 25.2,
  );

  // ============================================================================
  // 애니메이션 상수
  // ============================================================================

  /// 버튼 애니메이션 지속 시간
  static const Duration _buttonAnimationDuration = Duration(milliseconds: 200);

  /// 모드 버튼 추가 애니메이션 지속 시간
  static const Duration _modeButtonAnimationDuration = Duration(
    milliseconds: 300,
  );

  /// 스크롤 애니메이션 지속 시간
  static const Duration _scrollAnimationDuration = Duration(milliseconds: 300);

  /// 스크롤 애니메이션 커브
  static const Curve _scrollAnimationCurve = Curves.easeOut;

  /// 모드 버튼 애니메이션 커브
  static const Curve _modeButtonAnimationCurve = Curves.easeOut;

  // ============================================================================
  // 데이터 상수
  // ============================================================================

  /// 기본 모드 목록 (없음, 영화/드라마, 다큐멘터리, 예능)
  final List<Map<String, String>> _modes = const [
    {'label': '없음', 'mode': 'none'},
    {'label': '영화/드라마', 'mode': 'movie'},
    {'label': '다큐멘터리', 'mode': 'documentary'},
    {'label': '예능', 'mode': 'variety'},
  ];

  /// 헤드라인 텍스트 데이터 (제목 + 부제목)
  final List<Map<String, dynamic>> textList = const [
    {'text': '나에게 편한 자막 스타일을 골라보세요.', 'size': 80.0, 'weight': FontWeight.w600},
    {
      'text': '시청 중에도 언제든 쉽게 바꿀 수 있어요.',
      'size': 32.0,
      'weight': FontWeight.w500,
    },
  ];

  /// 소리의 높낮이 옵션 목록
  static const List<String> _soundPitchOptions = ['없음', '1단계', '2단계', '3단계'];

  /// 토글 설정 목록 (라벨과 키가 동일)
  static const List<String> _toggleLabels = ['화자 설정', '배경음 표시', '효과음 표시'];

  // 설정 영역 스크롤 컨트롤러 (해당 영역만 스크롤 + 스크롤바 표시용)
  final ScrollController _settingsScrollController = ScrollController();

  // 모드 선택 영역 스크롤 컨트롤러
  final ScrollController _modeSelectorScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _localToggles = Map.from(widget.toggles);
    _initialToggles = Map.from(widget.toggles);
    // 초기 소리의 높낮이 설정
    if (widget.initialSoundPitch != null) {
      _soundPitch = widget.initialSoundPitch!;
      _initialSoundPitch = widget.initialSoundPitch!;
    }
    // 초기 감정 색상 설정
    if (widget.initialEmotionColor != null) {
      _emotionColor = widget.initialEmotionColor!;
      _initialEmotionColor = widget.initialEmotionColor!;
    }
  }

  // 기본 모드인지 확인
  bool get _isDefaultMode {
    return _selectedMode == 'movie' ||
        _selectedMode == 'documentary' ||
        _selectedMode == 'variety';
  }

  // 커스텀 모드가 선택되었는지 확인
  bool get _isCustomModeSelected {
    return _selectedMode.startsWith('custom_');
  }

  // 값이 변경되었는지 확인
  bool get _hasChanges {
    return _modeName.trim() != _initialModeName.trim() ||
        _soundPitch != _initialSoundPitch ||
        _emotionColor != _initialEmotionColor ||
        !_mapsEqual(_localToggles, _initialToggles);
  }

  // ============================================================================
  // 헬퍼 함수
  // ============================================================================

  /// 두 Map이 동일한지 비교하는 헬퍼 함수 (토글 상태 비교용)
  bool _mapsEqual(Map<String, bool> map1, Map<String, bool> map2) {
    if (map1.length != map2.length) return false;
    for (var key in map1.keys) {
      if (map1[key] != map2[key]) return false;
    }
    return true;
  }

  /// 모드 설정을 초기값으로 리셋하는 함수
  void _resetToInitialValues() {
    _modeName = '';
    _soundPitch = widget.initialSoundPitch ?? '없음';
    _emotionColor = widget.initialEmotionColor ?? '없음';
    _localToggles = Map.from(widget.toggles);
    _initialModeName = '';
    _initialSoundPitch = widget.initialSoundPitch ?? '없음';
    _initialEmotionColor = widget.initialEmotionColor ?? '없음';
    _initialToggles = Map.from(widget.toggles);
  }

  /// 커스텀 모드의 설정값을 불러오는 함수
  void _loadCustomModeSettings(String modeId) {
    final customMode = _customModes.firstWhere(
      (m) => m['id'] == modeId,
      orElse: () => {},
    );
    if (customMode.isNotEmpty) {
      _modeName = customMode['name'] as String;
      _soundPitch = customMode['soundPitch'] as String;
      _emotionColor = customMode['emotionColor'] as String;
      _localToggles = Map<String, bool>.from(
        customMode['toggles'] as Map<String, bool>,
      );
      _initialModeName = _modeName;
      _initialSoundPitch = _soundPitch;
      _initialEmotionColor = _emotionColor;
      _initialToggles = Map<String, bool>.from(_localToggles);
    }
  }

  /// 패널을 모두 닫는 함수
  void _closeAllPanels() {
    setState(() {
      _isSoundPitchExpanded = false;
      _isEmotionColorExpanded = false;
    });
  }

  /// 모드 선택 영역을 왼쪽으로 스크롤하는 함수
  void _scrollModeSelectorLeft() {
    if (_modeSelectorScrollController.hasClients) {
      _modeSelectorScrollController.animateTo(
        (_modeSelectorScrollController.offset - 200).clamp(
          0.0,
          _modeSelectorScrollController.position.maxScrollExtent,
        ),
        duration: _scrollAnimationDuration,
        curve: _scrollAnimationCurve,
      );
    }
  }

  /// 모드 선택 영역을 오른쪽으로 스크롤하는 함수
  void _scrollModeSelectorRight() {
    if (_modeSelectorScrollController.hasClients) {
      _modeSelectorScrollController.animateTo(
        (_modeSelectorScrollController.offset + 200).clamp(
          0.0,
          _modeSelectorScrollController.position.maxScrollExtent,
        ),
        duration: _scrollAnimationDuration,
        curve: _scrollAnimationCurve,
      );
    }
  }

  /// 모드 선택 영역을 맨 앞으로 스크롤하는 함수 (새 모드 추가 후 사용)
  void _scrollModeSelectorToStart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_modeSelectorScrollController.hasClients) {
        _modeSelectorScrollController.animateTo(
          0.0,
          duration: _scrollAnimationDuration,
          curve: _scrollAnimationCurve,
        );
      }
    });
  }

  /// 새로운 커스텀 모드를 추가하는 함수
  void _addCustomMode() {
    if (_modeName.trim().isNotEmpty) {
      final newMode = {
        'id': 'custom_${DateTime.now().millisecondsSinceEpoch}',
        'name': _modeName.trim(),
        'soundPitch': _soundPitch,
        'emotionColor': _emotionColor,
        'toggles': Map<String, bool>.from(_localToggles),
      };
      setState(() {
        // 맨 앞에 추가 (인덱스 0에 삽입)
        _customModes.insert(0, newMode);
        _selectedMode = newMode['id'] as String;
        _initialModeName = _modeName.trim();
        _initialSoundPitch = _soundPitch;
        _initialEmotionColor = _emotionColor;
        _initialToggles = Map<String, bool>.from(_localToggles);
      });
      _scrollModeSelectorToStart();
    }
  }

  /// 커스텀 모드를 삭제하는 함수
  void _deleteCustomMode() {
    setState(() {
      _customModes.removeWhere((mode) => mode['id'] == _selectedMode);
      _selectedMode = 'none';
      _resetToInitialValues();
    });
  }

  @override
  void dispose() {
    _settingsScrollController.dispose();
    _modeSelectorScrollController.dispose();
    super.dispose();
  }

  // 미리보기 영상 넣을거임
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
      case '1단계':
        return 'assets/가_basic.png';
      case '없음':
      default:
        return 'assets/가_none.png';
    }
  }

  // 💡 공통 클릭 위젯 (GestureDetector + MouseRegion)
  Widget _clickable({required Widget child, VoidCallback? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: MouseRegion(cursor: SystemMouseCursors.click, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      //기본 레이아웃 설정 (RemotePointerOverlay 없이 직접 구성)
      body: LayoutBuilder(
        // 1024 이상이면 데스크탑 레이아웃, 미만이면 모바일/태블릿
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1024;

          return Center(
            child: Container(
              // 화면이 최대 1920까지 보이기
              constraints: const BoxConstraints(maxWidth: 1920),
              // 가장자리 여백
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 120.0 : 40.0,
                vertical: 60.0,
              ),
              // RemotePointerOverlay 없이 직접 child 표시
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 40,
                ),
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
                          width: _settingsSectionWidth * 2 + _sectionGap,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 왼쪽: 모드 설정 섹션 (고정 폭 718, 높이 제한)
                              SizedBox(
                                width: _settingsSectionWidth,
                                height: _settingsSectionHeight,
                                child: _buildSettingsSection(),
                              ),
                              const SizedBox(width: _sectionGap),
                              // 오른쪽: 미리보기 섹션
                              SizedBox(
                                width: _settingsSectionWidth,
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
        },
      ),
    );
  }

  //제목+부제목
  Column buildHeadLine() {
    return Column(
      children: textList.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Center(
            child: Text(
              item['text'] as String,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: item['size'] as double,
                fontWeight: item['weight'] as FontWeight,
                color: Colors.white,
                height: 1.19,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ============================================================================
  // UI 빌드 함수
  // ============================================================================

  /// 모드 선택 버튼 영역을 빌드하는 함수
  /// 왼쪽/오른쪽 화살표와 스크롤 가능한 모드 버튼들을 포함
  Widget _buildModeSelector() {
    return Container(
      width: _modeSelectorWidth,
      height: _modeSelectorHeight,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _modeSelectorBgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // 왼쪽 화살표 버튼
          buildArrowButton(Icons.chevron_left, onTap: _scrollModeSelectorLeft),
          // 모드 버튼들 (스크롤 가능)
          Expanded(
            child: SingleChildScrollView(
              controller: _modeSelectorScrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: [
                  // 없음 버튼 (맨 앞 고정, 오른쪽 margin 없음)
                  _buildModeButton('없음', 'none', hasRightMargin: false),
                  // 없음과 다음 버튼 사이 구분선
                  const SizedBox(width: _modeButtonSpacing),
                  Container(
                    width: 1,
                    height: _modeButtonHeight,
                    color: _separatorColor,
                  ),
                  const SizedBox(width: _modeButtonSpacing),
                  // 커스텀 모드 버튼들 (애니메이션 효과)
                  ...List.generate(_customModes.length, (index) {
                    final modeData = _customModes[index];
                    return AnimatedContainer(
                      duration: _modeButtonAnimationDuration,
                      curve: _modeButtonAnimationCurve,
                      child: _buildModeButton(
                        modeData['name'] as String,
                        modeData['id'] as String,
                      ),
                    );
                  }),
                  // 기본 모드 버튼들 (영화/드라마, 다큐멘터리, 예능)
                  ..._modes.skip(1).map((modeData) {
                    return _buildModeButton(
                      modeData['label']!,
                      modeData['mode']!,
                    );
                  }),
                ],
              ),
            ),
          ),
          // 오른쪽 화살표 버튼
          buildArrowButton(
            Icons.chevron_right,
            onTap: _scrollModeSelectorRight,
          ),
        ],
      ),
    );
  }

  /// 모드 버튼 위젯을 빌드하는 함수
  /// 커스텀 모드와 기본 모드를 모두 처리
  Widget _buildModeButton(
    String label,
    String mode, {
    bool hasRightMargin = true,
  }) {
    final isSelected = _selectedMode == mode;
    final isHovered = _hoveredModes[mode] ?? false;
    final bool isCustomMode = mode.startsWith('custom_');

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
            // 기본 모드 선택 시 초기값으로 리셋
            if (_isDefaultMode) {
              _resetToInitialValues();
            } else if (mode.startsWith('custom_')) {
              // 커스텀 모드 선택 시 저장된 설정값 불러오기
              _loadCustomModeSettings(mode);
            }
          });
        },
        child: Container(
          height: _modeButtonHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: hasRightMargin
              ? const EdgeInsets.only(right: _modeButtonSpacing)
              : null,
          decoration: BoxDecoration(
            // 커스텀 모드: 노란색 배경, 호버 시 주황색
            // 기본 모드: 회색 배경, 선택 시 투명
            color: isCustomMode
                ? (isHovered
                      ? _customModeButtonHoverBgColor
                      : _customModeButtonBgColor)
                : (isSelected
                      ? Colors.transparent
                      : (isHovered
                            ? _defaultModeButtonHoverBgColor
                            : _defaultModeButtonBgColor)),
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: _modeButtonTextStyle.copyWith(
                // 커스텀 모드: 항상 검정 텍스트, 기본 모드는 선택 시 흰색
                color: isCustomMode
                    ? Colors.black
                    : (isSelected ? Colors.white : Colors.black),
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
        thumbColor: WidgetStateProperty.all(_scrollbarColor),
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
                    const SizedBox(height: _fieldSpacing),
                    _buildSoundPitchField(),
                    const SizedBox(height: _fieldSpacing),
                    _buildEmotionColorField(),
                    const SizedBox(height: _fieldSpacing),
                    // 토글 설정들
                    ..._toggleLabels.map(
                      (label) => Padding(
                        padding: const EdgeInsets.only(bottom: _fieldSpacing),
                        child: _buildToggleRow(label, label),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2) 패널 외부 클릭 시 닫기 (설정 영역 전체 덮는 투명 레이어)
          // 패널보다 먼저 배치하여 패널이 위에 오도록 함
          if (_isSoundPitchExpanded || _isEmotionColorExpanded)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeAllPanels,
                child: Container(color: Colors.transparent),
              ),
            ),

          // 3) 소리의 높낮이 옵션 패널 (다른 행 위로 겹쳐 표시)
          // 패널이 외부 클릭 레이어 위에 오도록 나중에 배치
          if (_isSoundPitchExpanded)
            Positioned(
              top: _soundPitchPanelTop,
              left: _soundPitchPanelLeft,
              child: _buildSoundPitchPanel(),
            ),

          // 4) 감정 색상 옵션 패널 (다른 행 위로 겹쳐 표시)
          // 패널이 외부 클릭 레이어 위에 오도록 나중에 배치
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
    final bool isDisabled = _isDefaultMode;
    return Row(
      children: [
        _buildSettingLabel('모드 이름'),
        const SizedBox(width: _labelGap),
        Expanded(
          child: Opacity(
            opacity: isDisabled ? 0.5 : 1.0,
            child: Container(
              height: _inputFieldHeight,
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
                      enabled: !isDisabled,
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
                  const Text('10자 이내', style: _modeNameCounterTextStyle),
                ],
              ),
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
          width: _soundPitchFieldWidth,
          child: Row(
            children: [
              // 왼쪽 소리의 높낮이 이미지
              Container(
                width: _soundPitchImageSize,
                height: _soundPitchImageSize,
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
                      // 디버깅: 이미지 로드 실패 시 빨간색 배경으로 표시
                      return Container(
                        width: _soundPitchImageSize,
                        height: _soundPitchImageSize,
                        color: Colors.red.withOpacity(0.3),
                        child: const Center(
                          child: Icon(Icons.error, color: Colors.red, size: 20),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // 오른쪽 입력 필드 (340px)
              Expanded(
                child: Opacity(
                  opacity: _isDefaultMode ? _disabledFieldOpacity : 1.0,
                  child: _clickable(
                    onTap: _isDefaultMode
                        ? null
                        : () {
                            setState(() {
                              _isSoundPitchExpanded = !_isSoundPitchExpanded;
                            });
                          },
                    child: Container(
                      height: _dropdownFieldHeight,
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 소리의 높낮이 옵션 패널을 빌드하는 함수
  /// 드롭다운 형태로 옵션 목록을 표시
  Widget _buildSoundPitchPanel() {
    return Material(
      elevation: 8,
      color: Colors.transparent,
      child: Container(
        width: _soundPitchPanelWidth,
        decoration: BoxDecoration(
          color: _fieldBgColor,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(_panelShadowOpacity),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _soundPitchOptions
              .map((option) => _buildSoundPitchOption(option))
              .toList(),
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
        height: _panelOptionHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(_selectedOptionBgOpacity)
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
          width: _emotionColorFieldWidth,
          child: Opacity(
            opacity: _isDefaultMode ? _disabledFieldOpacity : 1.0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _isDefaultMode
                  ? null
                  : () {
                      setState(() {
                        _isEmotionColorExpanded = !_isEmotionColorExpanded;
                      });
                    },
              child: MouseRegion(
                cursor: _isDefaultMode
                    ? SystemMouseCursors.basic
                    : SystemMouseCursors.click,
                child: Container(
                  height: _dropdownFieldHeight,
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
                      Row(
                        children: [
                          Text(_emotionColor, style: _fieldTextStyle),
                          // 선택된 감정 색상 팔레트 미리보기 (없음 제외)
                          if (_emotionColor != '없음') ...[
                            const SizedBox(width: 14),
                            Row(
                              children: (() {
                                List<Color> palette = [];
                                if (_emotionColor == '1단계') {
                                  palette = _getColorPalette(1);
                                } else if (_emotionColor == '2단계') {
                                  palette = _getColorPalette(2);
                                } else if (_emotionColor == '3단계') {
                                  palette = _getColorPalette(3);
                                }
                                return palette
                                    .map(
                                      (color) => Container(
                                        width: _colorPalettePreviewWidth,
                                        height: _colorPalettePreviewHeight,
                                        margin: const EdgeInsets.only(right: 1),
                                        color: color,
                                      ),
                                    )
                                    .toList();
                              })(),
                            ),
                          ],
                        ],
                      ),
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
          ),
        ),
      ],
    );
  }

  /// 감정 색상 옵션 패널을 빌드하는 함수
  /// 드롭다운 형태로 색상 팔레트 옵션 목록을 표시
  Widget _buildEmotionColorPanel() {
    return Material(
      elevation: 8,
      color: Colors.transparent,
      child: Container(
        width: _emotionColorFieldWidth,
        decoration: BoxDecoration(
          color: _fieldBgColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(_panelShadowOpacity),
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

    void selectEmotion() {
      setState(() {
        _emotionColor = label;
        _isEmotionColorExpanded = false;
      });
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: selectEmotion,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: _emotionColorOptionHeight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withOpacity(_selectedOptionBgOpacity)
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
                        (color) => GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: selectEmotion,
                          child: Container(
                            width: _colorPaletteBoxWidth,
                            height: _colorPaletteBoxHeight,
                            margin: const EdgeInsets.only(right: 1),
                            decoration: BoxDecoration(
                              color: color,
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 1)
                                  : null,
                            ),
                          ),
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
                    child: Text('권장', style: _recommendedBadgeTextStyle),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // 색상 팔레트 반환 (단계별)
  List<Color> _getColorPalette(int level) {
    switch (level) {
      case 1:
        return [
          const Color(0xFFFFCDD2), // 연빨강
          const Color(0xFFFFE599), // 연노랑/주황
          const Color(0xFFFFF9C4), // 연노랑
          const Color(0xFFC8E6C9), // 연초록
          const Color(0xFFBBDEFB), // 연파랑
          const Color(0xFFE1BEE7), // 연보라
          const Color(0xFFEEEEEE), // 연회색
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

  /// 토글 설정 행을 빌드하는 함수
  /// 라벨과 Switch 위젯을 포함
  Widget _buildToggleRow(String label, String toggleKey) {
    final bool value = _localToggles[toggleKey] ?? false;
    final bool isDisabled = _isDefaultMode;
    return Opacity(
      opacity: isDisabled ? _disabledFieldOpacity : 1.0,
      child: Row(
        children: [
          _buildSettingLabel(label, width: 200),
          const SizedBox(width: 40),
          Switch(
            value: value,
            onChanged: isDisabled
                ? null
                : (v) {
                    setState(() {
                      _localToggles[toggleKey] = v;
                    });
                  },
            activeThumbColor: _primaryBlue,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: _toggleInactiveTrackColor,
          ),
        ],
      ),
    );
  }

  // 오른쪽 섹션 (미리보기 + 버튼들)
  Widget _buildRightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('미리보기', style: _previewTitleTextStyle),
        const SizedBox(height: 8),
        Container(
          width: _previewWidth,
          height: _previewHeight,
          decoration: BoxDecoration(
            color: _previewBgColor,
            borderRadius: BorderRadius.circular(2.8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.8),
            child: Stack(
              children: [
                Image.asset(
                  _previewImage,
                  width: _previewWidth,
                  height: _previewHeight,
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
                        style: _previewBottomTextStyle,
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
          width: _previewWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 커스텀 모드가 선택되었으면 삭제하기, 아니면 추가하기
              _isCustomModeSelected
                  ? _buildDeleteButton(
                      _buttonWidth,
                      _buttonHeight,
                      _deleteCustomMode,
                    )
                  : _buildAddButton(
                      _buttonWidth,
                      _buttonHeight,
                      _hasChanges &&
                              !_isDefaultMode &&
                              _modeName.trim().isNotEmpty
                          ? _addCustomMode
                          : null,
                    ),
              const SizedBox(width: _buttonSpacing),
              _buildApplyButton(
                text: '적용하기',
                width: _buttonWidth,
                height: _buttonHeight,
                onTap: () {
                  Navigator.pop(context, {
                    'toggles': _localToggles,
                    'customModes': _customModes,
                    'selectedMode': _selectedMode,
                    'soundPitch': _soundPitch,
                    'emotionColor': _emotionColor,
                  });
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
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: MouseRegion(
          cursor: isDisabled
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          onEnter: (_) {
            if (!isDisabled) {
              setState(() => _isAddHovered = true);
            }
          },
          onExit: (_) {
            if (!isDisabled) {
              setState(() => _isAddHovered = false);
            }
          },
          child: AnimatedContainer(
            duration: _buttonAnimationDuration,
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: _isAddHovered
                  ? _addDeleteButtonHoverBgColor
                  : _addDeleteButtonBgColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _primaryBlue, width: 1),
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
      ),
    );
  }

  // 삭제하기 버튼 (피그마 디자인: 어두운 배경 + 파란색 테두리 + 삭제 아이콘)
  Widget _buildDeleteButton(double width, double height, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _isAddHovered = true);
        },
        onExit: (_) {
          setState(() => _isAddHovered = false);
        },
        child: AnimatedContainer(
          duration: _buttonAnimationDuration,
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: _isAddHovered
                ? _addDeleteButtonHoverBgColor
                : _addDeleteButtonBgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _primaryBlue, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.delete_outline,
                  color: _primaryBlue,
                  size: 24,
                ),
              ),
              SizedBox(width: 10),
              Text(
                '삭제하기',
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
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isApplyHovered = true),
        onExit: (_) => setState(() => _isApplyHovered = false),
        child: AnimatedContainer(
          duration: _buttonAnimationDuration,
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: _isApplyHovered ? _applyButtonHoverColor : _primaryBlue,
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
      ),
    );
  }
}
