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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                        // 왼쪽: 모드 설정 섹션 (고정 폭 718)
                        SizedBox(width: 718, child: _buildSettingsSection()),
                        const SizedBox(width: 60),
                        // 오른쪽: 미리보기 섹션 (고정 폭 718)
                        SizedBox(width: 718, child: _buildRightSection()),
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
      children: [
        const Center(
          child: Text(
            '나에게 편한 자막 스타일을 골라보세요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 80,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.193,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // 부제목
        const Center(
          child: Text(
            '시청 중에도 언제든 쉽게 바꿀 수 있어요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.19, //45.35 / 38,
            ),
          ),
        ),
      ],
    );
  }

  // 모드 선택 버튼들
  Widget _buildModeSelector() {
    return Container(
      width: 1048,
      height: 75,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: _modes.map((modeData) {
          final isSelected = _selectedMode == modeData['mode'];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMode = modeData['mode']!;
              });
            },
            child: Container(
              width: 250,
              height: 59,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: Colors.white, width: 1)
                    : Border.all(color: Colors.transparent, width: 1),
              ),
              child: Center(
                child: Text(
                  modeData['label']!,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 39.2 / 28,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 설정 섹션 (피그마 Frame 폭 718 기준, 전용 스크롤바 스타일)
  Widget _buildSettingsSection() {
    return ScrollbarTheme(
      data: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(const Color(0xFFBABFC4)), // 피그마 색상
        trackColor: WidgetStateProperty.all(Colors.transparent), // 트랙은 보이지 않게
        radius: const Radius.circular(99),
        thickness: WidgetStateProperty.all(8),
      ),
      //스크롤바
      child: Scrollbar(
        controller: _settingsScrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _settingsScrollController,
          child: Padding(
            //길이 자동 설정임
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 모드 이름
                _buildModeNameField(),
                const SizedBox(height: 40),
                // 소리의 높낮이
                _buildSoundPitchField(),
                const SizedBox(height: 40),
                // 감정 색상
                _buildEmotionColorField(),
                const SizedBox(height: 40),
                // 화자 설정
                _buildToggleRow('화자 설정', '화자 설정'),
                const SizedBox(height: 40),
                // 배경음 표시
                _buildToggleRow('배경음 표시', '배경음 표시'),
                const SizedBox(height: 40),
                // 효과음 표시
                _buildToggleRow('효과음 표시', '효과음 표시'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 공통 설정 라벨 (왼쪽 텍스트)
  Widget _buildSettingLabel(String text, {double width = 220}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 35,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          height: 53.2 / 38,
        ),
      ),
    );
  }

  // 모드 이름 입력 필드
  Widget _buildModeNameField() {
    return Row(
      children: [
        _buildSettingLabel('모드 이름'),
        const SizedBox(width: 18),
        Expanded(
          child: Container(
            height: 79,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
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
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 39.2 / 28,
                    ),
                    decoration: const InputDecoration(
                      hintText: '모드 이름을 적어주세요',
                      hintStyle: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 39.2 / 28,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Text(
                  '10자 이내',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
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

  // 소리의 높낮이 필드
  Widget _buildSoundPitchField() {
    return Row(
      children: [
        _buildSettingLabel('소리의 높낮이'),
        const SizedBox(width: 18),
        SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 상단 선택 박스
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSoundPitchExpanded = !_isSoundPitchExpanded;
                  });
                },
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _soundPitch,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 39.2 / 28,
                        ),
                      ),
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
              // 펼쳐졌을 때: 아래 패널 (없음 / 1단계 / 2단계 / 3단계)
              if (_isSoundPitchExpanded) ...[
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(10),
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
              ],
            ],
          ),
        ),
      ],
    );
  }

  // 소리의 높낮이 옵션 한 줄
  Widget _buildSoundPitchOption(String label) {
    final bool isSelected = _soundPitch == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _soundPitch = label;
          _isSoundPitchExpanded = false;
        });
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? Colors.white.withOpacity(0.15)
              : Colors.transparent,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // 감정 색상 필드
  Widget _buildEmotionColorField() {
    return Row(
      children: [
        _buildSettingLabel('감정 색상'),
        const SizedBox(width: 18),
        Expanded(
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _emotionColor,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 39.2 / 28,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // 드롭다운 메뉴 표시
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: const Color(0xFF333333),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      builder: (context) => Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: ['없음', '빨강', '파랑', '초록'].map((option) {
                            return ListTile(
                              title: Text(
                                option,
                                style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _emotionColor = option;
                                });
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                      size: 32,
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

  // 토글 행
  Widget _buildToggleRow(String label, String toggleKey) {
    final bool value = _localToggles[toggleKey] ?? false;
    return Row(
      children: [
        _buildSettingLabel(label, width: label == '화자 설정' ? 200 : 200),
        //글자랑 토글 거리 40
        const SizedBox(width: 40),
        Switch(
          value: value,
          onChanged: (v) {
            setState(() {
              _localToggles[toggleKey] = v;
            });
          },
          activeColor: const Color(0xFF0A9B02),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFF7F7F7F),
        ),
      ],
    );
  }

  // 오른쪽 섹션 (미리보기 + 버튼들)
  Widget _buildRightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 미리보기
        const Text(
          '미리보기',
          style: TextStyle(
            fontFamily: 'Pretendard',
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
                          fontFamily: 'Pretendard',
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
        // 🔥 추가하기, 적용하기 버튼 (미리보기 폭 내에서 오른쪽 정렬)
        SizedBox(
          width: 560,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildGradientButton('추가하기', 180, 73, () {
                // 추가하기 동작
              }),
              const SizedBox(width: 24),
              _buildGradientButton('적용하기', 180, 73, () {
                Navigator.pop(context, _localToggles);
              }),
            ],
          ),
        ),
      ],
    );
  }

  // 그라데이션 버튼
  Widget _buildGradientButton(
    String text,
    double width,
    double height,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF315BD5), Color(0xFF9232DD)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 38,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 53.2 / 38,
            ),
          ),
        ),
      ),
    );
  }
}
