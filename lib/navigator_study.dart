import 'package:flutter/material.dart';

// 네비게이션 유틸리티 클래스 ( 네비게이션 공통 사용 )
class NavigatorStudy {
  /* Offset 설명
    Offset(0.0, 0.0) = 화면 중앙
    Offset(1.0, 0.0) = 화면 오른쪽 밖
    Offset(-1.0, 0.0) = 화면 왼쪽 밖
    Offset(0.0, 1.0) = 화면 아래쪽 밖
  */
  /* Curves 곡선 설정
   Curves.linear       // 일정한 속도 ━━━━━
   Curves.easeIn       // 천천히 시작 ╱━━━━
   Curves.easeOut      // 천천히 끝   ━━━━╲
   Curves.bounceOut    // 통통 튀는   ━━━╱╲╱
  */

  // 슬라이드 애니메이션으로 화면 교체 (pushReplacement)
  static void slideReplaceTo(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // 오른쪽 밖에서 시작
          const end = Offset.zero; // 화면 중앙에서 끝

          const curve = Curves.easeInOutCubic; // 부드러운 곡선

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          // 애니메이션 적용
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  // 슬라이드 애니메이션으로 화면 이동 (push)
  static void slideTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }
}
