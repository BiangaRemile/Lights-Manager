import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  final bool isbold;
  const CustomText({super.key, required this.text, required this.size, this.color, this.isbold=false});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      fontSize: size,
      color: color,
      fontWeight: isbold? FontWeight.bold: FontWeight.w400
    ),);
  }
}
