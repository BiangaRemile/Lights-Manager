import 'package:flutter/material.dart';
import 'package:lights/app/components/btn_list.dart';
import 'package:lights/app/components/custom_text.dart';
import '../components/list_view_components/client_item.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {

  List clients = ["Remile", "Nathan", "Claudel", "Gloire", "Miradi", "Rolly", "John", "Beni", "Winner", "Winnel"];
  bool animated = false;
  int buttonSwitch = 0;

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        title: const CustomText(text: "Clients", size: 30, isbold: true,),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top:20, bottom: 10 ),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 70, bottom: 10),
              child: ListView.builder(
                itemCount: clients.length,
                itemBuilder: (builder, index) {
                  return ClientItem(client: clients[index], animate: animated, index: index,);
                }
              ),
            ),
            Positioned(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomTextButton(
                    text: "Tous",
                    isselected: buttonSwitch == 0? true: false,
                    onPressed: () {setState(() {
                      buttonSwitch = 0;
                    });},
                  ),
                  CustomTextButton(
                    text: "Sans lampe",
                    isselected: buttonSwitch == 1? true: false,
                    onPressed: () {setState(() {
                      buttonSwitch = 1;
                    });},
                  ),
                  CustomTextButton(
                    text: "Avec lampe",
                    isselected: buttonSwitch == 2? true: false,
                    onPressed: () {setState(() {
                      buttonSwitch = 2;
                    });},
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
  
  Future startAnimation() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      animated = true;
    });
  }
}
