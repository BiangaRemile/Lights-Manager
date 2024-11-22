import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lights/app/components/custom_text.dart';

class CustomTextButton extends StatelessWidget {
  final text;
  final Color? color;
  final bool isselected;
  final Function() onPressed;
  const CustomTextButton({super.key, this.text, this.color, this.isselected=false, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isselected? Colors.amber[100]: Colors.grey[300],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        splashColor: Colors.transparent,
        child: CustomText(text: text, size: 14,),
      ),
    );
  }
}
