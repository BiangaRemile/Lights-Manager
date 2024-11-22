import 'package:flutter/material.dart';

import '../../assets.dart';

class HOMEIMAGE extends StatelessWidget {
  const HOMEIMAGE({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 4),
                color: Colors.white
            )
          ]
      ),
      child: Image.asset(adminImage, width: 30, height: 30,),
    );
  }
}
