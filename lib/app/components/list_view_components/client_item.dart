import 'package:flutter/material.dart';
import '../custom_text.dart';

class ClientItem extends StatelessWidget {
  const ClientItem({
    super.key,
    required this.animate,
    required this.index, required this.client,
  });

  final bool animate;
  final String client;
  final int index;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Color primary = Theme.of(context).primaryColor;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      width: screenWidth,
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 10),
      transform: Matrix4.translationValues(!animate? -screenWidth: 0, 0, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
      ),
      child: ListTile(
        leading: Icon(Icons.person, color: primary,),
        title: CustomText(text: client, size: 14, isbold: true),
        subtitle: const CustomText(text: "Vaku, 24, Kimwenza", size: 12),
        trailing: const SizedBox(
          width: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("1"),
              Icon(Icons.lightbulb, color: Colors.grey,)
            ],
          ),
        ),
      ),
    );
  }
}