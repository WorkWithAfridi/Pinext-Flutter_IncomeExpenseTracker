import 'package:flutter/material.dart';

class CustomTransitionPageRoute extends PageRouteBuilder {
  final Widget childWidget;

  CustomTransitionPageRoute({required this.childWidget})
      : super(
          transitionDuration: const Duration(milliseconds: 200),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, animation, secondaryAnimation) => childWidget,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(animation),
      child: childWidget,
    );
  }
}
