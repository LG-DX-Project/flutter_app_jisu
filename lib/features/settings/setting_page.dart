// // lib/features/screens/home/setting_page.dart
// import 'package:flutter/material.dart';

// class SettingPage extends StatefulWidget {
//   final Map<String, bool> toggles;

//   const SettingPage({super.key, required this.toggles});

//   @override
//   State<SettingPage> createState() => _SettingPageState();
// }

// class _SettingPageState extends State<SettingPage> {
//   late Map<String, bool> _localToggles;

//   @override
//   void initState() {
//     super.initState();
//     _localToggles = Map.from(widget.toggles);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         title: const Text(
//           "세부 설정",
//           style: TextStyle(color: Colors.white, fontSize: 28),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context, _localToggles);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: _localToggles.keys.map((label) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 24),
//               child: _buildToggleItem(label),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildToggleItem(String label) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontFamily: 'Pretendard',
//             fontSize: 28,
//             color: Colors.white,
//           ),
//         ),
//         Switch(
//           value: _localToggles[label]!,
//           onChanged: (v) {
//             setState(() => _localToggles[label] = v);
//           },
//           activeColor: const Color(0xFF0A9B02),
//           inactiveThumbColor: Colors.white,
//           inactiveTrackColor: const Color(0xFF7F7F7F),
//         ),
//       ],
//     );
//   }
// }
