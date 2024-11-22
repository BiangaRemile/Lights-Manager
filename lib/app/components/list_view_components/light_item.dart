import 'package:flutter/material.dart';

import '../custom_text.dart';

class LightItem extends StatelessWidget {
  const LightItem({
    super.key,
    required this.animate,
    required this.index, required this.lamp, required this.client,
  });

  final bool animate;
  final String lamp;
  final String client;
  final int index;

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      width: screenWidth,
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 10),
      transform: Matrix4.translationValues(!animate? -screenWidth: 0, 0, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
      ),
      child: ListTile(
        leading: Icon(Icons.lightbulb, color: primary,),
        title: CustomText(text: lamp, size: 14, isbold: true),
        subtitle: CustomText(text: client, size: 14,color: Colors.grey,),
        trailing: const Icon(Icons.lightbulb_outline, color: Colors.green,),
      ),
    );
  }
}