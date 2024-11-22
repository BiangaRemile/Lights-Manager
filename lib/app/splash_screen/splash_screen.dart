import 'package:flutter/material.dart';
import 'package:lights/app/authentification/login.dart';
import 'package:lights/app/components/custom_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeScreen();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const Center(
        child: CustomText(
          text: 'LAMPS MANAGER',
          size: 40,
          color: Colors.white,
          isbold: true
        ),
      ),
    );
  }

  Future changeScreen() async{
    await Future.delayed(const Duration(milliseconds: 1500));
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>const LOGIN()), (Route route) => false);
  }
}
