import 'package:flutter/material.dart';

/// A reusable navigation transition used across all screens in the hierarchy.
/// Slides child in from the right with a simultaneous fade.
Route<T> slideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOutCubic));
      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}
