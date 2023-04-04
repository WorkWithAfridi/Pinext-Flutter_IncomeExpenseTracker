import 'package:flutter/material.dart';

Widget TurnIntoAnimatedWidget(Widget child, Animation<double> animation) {
  return FadeTransition(
    opacity: Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animation),
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    ),
  );
}
