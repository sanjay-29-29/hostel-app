import 'dart:math' as math;
import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle style;

  static const double baseWidth = 414.0;
  static const double baseHeight = 896.0;

  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const ResponsiveText(
    this.text, {
    super.key,
    required this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  double _responsiveFontSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthScale = size.width / baseWidth;
    final heightScale = size.height / baseHeight;
    double scale = math.min(widthScale, heightScale);
    scale = scale.clamp(0.70, 1.30);
    return (style.fontSize ?? 14) * scale;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(
        fontSize: _responsiveFontSize(context),
        fontFamily: style.fontFamily ?? 'Poppins',
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
