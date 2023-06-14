import 'package:flutter/material.dart';

class BounceIcon extends StatefulWidget {
  const BounceIcon({required this.icon, required this.onTap, super.key});
  final IconData icon;
  final Function onTap;

  @override
  _BounceIconState createState() => _BounceIconState();
}

class _BounceIconState extends State<BounceIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0.8, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastEaseInToSlowEaseOut),
    );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.reset();
        _controller.forward();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Icon(
              widget.icon,
              size: 16,
            ),
          );
        },
      ),
    );
  }
}
