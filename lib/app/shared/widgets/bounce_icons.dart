import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/fonts.dart';
import 'package:pinext/app/app_data/theme_data/colors.dart';

class BounceIcon extends StatefulWidget {
  BounceIcon({
    required this.icon,
    required this.onTap,
    super.key,
    this.size = 16,
    this.title,
    this.color = primaryColor,
  });
  final IconData icon;
  final Function onTap;
  double size;
  String? title;
  Color color;

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
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.6, end: 1).animate(
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
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: widget.size,
                    color: widget.color,
                  ),
                  if (widget.title == null)
                    const SizedBox.shrink()
                  else
                    Column(
                      children: [
                        const SizedBox(
                          height: 1,
                        ),
                        Text(
                          widget.title!,
                          style: regularTextStyle.copyWith(
                            fontSize: 12,
                            color: widget.color,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
