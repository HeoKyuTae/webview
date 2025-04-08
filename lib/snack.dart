import 'package:flutter/material.dart';
import 'package:webconnect/theme_color.dart';

class Snack {
  ThemeColor _themeColor = ThemeColor();
  
  // ✅ 상단 SnackBar 함수
  void showTopSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    final animationController = AnimationController(
      vsync: Navigator.of(context),
      duration: Duration(milliseconds: 250),
    );
    final opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animationController);
    final slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(animationController);

    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 80,
            left: MediaQuery.of(context).size.width * 0.1,
            width: MediaQuery.of(context).size.width * 0.8,
            child: SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: opacityAnimation,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _themeColor.themeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);
    animationController.forward(); // ✅ 애니메이션 시작

    // ✅ 2초 후 자동 삭제 (애니메이션 포함)
    Future.delayed(Duration(seconds: 2), () async {
      await animationController.reverse(); // ✅ 부드럽게 사라짐
      overlayEntry.remove();
    });
  }
}
