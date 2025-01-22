import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String? text;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final BoxShadow? boxShadow;

  const MyText(
    String s, {
    super.key,
    this.text,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.backgroundColor,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(15.0),
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ??
            Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          boxShadow ??
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // Shadow position
              ),
        ],
      ),
      padding: padding,
      child: Text(
        text!,
        textAlign: textAlign,
        style: textStyle ??
            TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
