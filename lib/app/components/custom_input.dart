import 'package:flutter/material.dart';

class CUSTOMTEXTFIELD extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool isRequired;
  const CUSTOMTEXTFIELD({super.key, required this.controller, required this.hintText, this.isRequired=false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: isRequired? (value) {
        if(value!.trim().isEmpty) {
          return "Ce champs doit etre rempli";
        }
        return null;
      }: null,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black
          )
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green,
            width: 2
          )
        ),
        filled: true,
        fillColor: Colors.white
      ),
    );
  }
}
