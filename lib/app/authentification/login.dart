import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lights/app/components/custom_button.dart';
import 'package:lights/app/components/custom_input.dart';
import 'package:lights/app/components/custom_text.dart';
import 'package:lights/app/components/home_image.dart';
import 'package:lights/app/pages/home.dart';

class LOGIN extends StatefulWidget {
  const LOGIN({super.key});

  @override
  State<LOGIN> createState() => _LOGINState();
}

class _LOGINState extends State<LOGIN> {

  final TextEditingController adminCode = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const HOMEIMAGE(),
                      const CustomText(text: "Admin Login", size: 25, isbold: true),
                      CUSTOMTEXTFIELD(controller: adminCode, hintText: '', isRequired: true),
                      CUSTOMBUTTON(size: double.infinity, color: Colors.white, onPress: () {
                        if(_formKey.currentState!.validate()) {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>const HOME()), (route) => false);
                        }
                      })
                    ],
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: CustomText(text: "Done by Coder Edge", size: 12, isbold: false,)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
