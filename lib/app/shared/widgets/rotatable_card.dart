import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pinext/app/app_data/app_constants/domentions.dart';

class RotatableCard extends StatefulWidget {
  const RotatableCard({
    super.key,
    required this.front,
    required this.back,
  });
  final Widget front;
  final Widget back;

  @override
  _RotatableCardState createState() => _RotatableCardState();
}

class _RotatableCardState extends State<RotatableCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;

  bool _showFront = true;
  double _angle = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotation = Tween<double>(begin: 0, end: 0).animate(_controller);

    _rotation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_showFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    _showFront = !_showFront;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // print("Pan update called");
    final position = details.localPosition;
    final dx = position.dx - (context.size!.width / 2);
    final dy = position.dy - (context.size!.height / 2);
    final angle = atan2(dy, dx);
    setState(() {
      _angle = angle;
    });
    // _angle = _angle % (2 * pi);
    final value = _angle / (2 * pi);
    if (_showFront == false && value >= -0.25 && value < 0) {
      _showFront = true;
      return;
    }
    if (value >= 0.25 || value <= -0.25) {
      _showFront = false;
      _angle -= pi;
    } else if (value > 0 && value < 0.25) {
      _showFront = true;
    }
  }

  void _onPanEnd(DragEndDetails details) {
    print('Pan end called');
    final velocity = details.velocity.pixelsPerSecond.distance;
    if (velocity > 1000) {
      if (_angle > 0) {
        _angle += pi;
      } else {
        _angle -= pi;
      }
    }
    if (_angle < 0) {
      _angle += 2 * pi;
    }
    _angle = _angle % (2 * pi);
    final value = _angle / (2 * pi);
    // if (value > 0.25) {
    //   _showFront = false;
    //   _angle -= pi;
    // } else {
    //   _showFront = true;
    // }
    setState(() {});
    _controller.animateTo(
      value,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: getWidth(context) * .8,
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_rotation.value + _angle),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: _showFront ? widget.front : widget.back,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
