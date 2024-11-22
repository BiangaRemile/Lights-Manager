import 'package:flutter/material.dart';
import 'package:lights/app/components/custom_text.dart';

class CUSTOMBUTTON extends StatelessWidget {
  final double? size;
  final Color? color;
  final Function() onPress;
  const CUSTOMBUTTON({super.key, this.size, this.color, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: 55,
      child: MaterialButton(
        onPressed: onPress,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: const CustomText(text: "Se connecter", size: 15,),
      ),
    );
  }
}
