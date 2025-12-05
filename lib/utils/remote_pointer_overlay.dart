// lib/widgets/remote_pointer_overlay.dart

import 'dart:async';
import 'package:flutter/material.dart';
// Firebase 연동 시 아래 주석 해제
// import 'package:cloud_firestore/cloud_firestore.dart';

class RemotePointerOverlay extends StatefulWidget {
  final Widget child;

  const RemotePointerOverlay({super.key, required this.child});

  @override
  State<RemotePointerOverlay> createState() => _RemotePointerOverlayState();
}

class _RemotePointerOverlayState extends State<RemotePointerOverlay> {
  double _nx = 0.5; // 정규화 좌표(0~1)
  double _ny = 0.5;

  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();

    // TODO: Firestore나 WebSocket 연결 시 여기에 구독 추가
    // 테스트용으로는 변화 없음
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;
        final double h = constraints.maxHeight;

        // 좌표 변환
        final px = _nx * w;
        final py = _ny * h;

        return Stack(
          children: [
            /// 뒤에 깔리는 페이지 전체
            Positioned.fill(child: widget.child),

            /// TV 화면 위 공통 포인터
            Positioned(
              left: px - 8,
              top: py - 8,
              child: IgnorePointer(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF3A7BFF).withOpacity(0.9),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
