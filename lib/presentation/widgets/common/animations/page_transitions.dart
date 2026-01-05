import 'package:flutter/material.dart';

/// 시간 포탈 페이지 전환 애니메이션
/// 
/// 화면이 시간 포탈을 통과하는 것처럼 회전하며 전환
class TimePortalPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  
  TimePortalPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            );
            
            return FadeTransition(
              opacity: curvedAnimation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.85, end: 1.0).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );
}

/// 골드 글로우 페이지 전환 애니메이션
class GoldenPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  
  GoldenPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuint,
            );
            
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: FadeTransition(
                opacity: curvedAnimation,
                child: child,
              ),
            );
          },
        );
}
