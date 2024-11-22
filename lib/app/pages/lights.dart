import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lights/app/components/custom_text.dart';
import '../components/btn_list.dart';
import '../components/list_view_components/light_item.dart';

class LightsPage extends StatefulWidget {
  const LightsPage({super.key});

  @override
  State<LightsPage> createState() => _LightsPageState();
}

class _LightsPageState extends State<LightsPage> {

  bool animate = false;
  int buttonSwitch = 0;
  List lamps = ["ATYZY", "ARZ56", "YZYZ5", "2425Z", "ATYZY", "ARZ56", "YZYZ5", "2425Z", "ARZ56", "YZYZ5", "2425Z", "ATYZY", "ARZ56", "YZYZ5", "2425Z"];

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: AppBar(
        title: const CustomText(text: "Lampes", size: 30, isbold: true,),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top:20, bottom: 10 ),
        height: screenHeight,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              child: ListView.builder(
                itemBuilder: (builder, index) {
                  return LightItem(animate: animate, lamp: lamps[index], index: index, client: 'Remile Bianga',);
                },
                itemCount: lamps.length,
              ),
            ),
            Positioned(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomTextButton(
                    text: "Toutes",
                    isselected: buttonSwitch==0? true: false,
                    onPressed: () {setState(() {
                      buttonSwitch = 0;
                    });},
                  ),
                  CustomTextButton(
                    text: "Dispo",
                    isselected: buttonSwitch==1? true: false,
                    onPressed: () {setState(() {
                      buttonSwitch = 1;
                    });},
                  ),
                  CustomTextButton(
                    text: "Indispo",
                    isselected: buttonSwitch==2? true: false,
                    onPressed: () {setState(() {
                      buttonSwitch = 2;
                    });},
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future startAnimation() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      animate = true;
    });
  }
}
