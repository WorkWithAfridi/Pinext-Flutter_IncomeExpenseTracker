import 'package:flutter/widgets.dart';

class AnimatedCounterTextWidget extends StatefulWidget {
  const AnimatedCounterTextWidget({
    Key? key,
    required this.begin,
    required this.end,
    this.precision = 0,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 250),
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  }) : super(key: key);

  final double begin;
  final double end;
  final int precision;
  final Curve curve;
  final Duration duration;

  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;

  @override
  _AnimatedCounterTextWidgetState createState() => _AnimatedCounterTextWidgetState();
}

class _AnimatedCounterTextWidgetState extends State<AnimatedCounterTextWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = AnimationController(duration: widget.duration, vsync: this);
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: _controller, curve: widget.curve);
    _animation = Tween<double>(begin: widget.begin, end: widget.end).animate(curvedAnimation);
    _controller.forward();

    return _AnimatedCounterTextWidget(
      key: UniqueKey(),
      animation: _animation,
      precision: widget.precision,
      style: widget.style,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      locale: widget.locale,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textScaleFactor: widget.textScaleFactor,
      maxLines: widget.maxLines,
      semanticsLabel: widget.semanticsLabel,
    );
  }
}

class _AnimatedCounterTextWidget extends AnimatedWidget {
  const _AnimatedCounterTextWidget({
    Key? key,
    required this.animation,
    required this.precision,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  }) : super(key: key, listenable: animation);

  final Animation<double> animation;
  final int precision;

  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) => Text(
        animation.value.toStringAsFixed(precision),
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
      );
}
