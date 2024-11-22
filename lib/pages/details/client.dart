import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lights/data/persons.dart';
import 'package:lights/pages/home.dart';
import 'package:lights/qr_code/scanner.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../database_services/helper.dart';

class ClientDetails extends StatefulWidget {
  final Client client;
  final Function refreshListPersonPage;
  const ClientDetails({super.key, required this.client, required this.refreshListPersonPage});

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {

  final db = DatabaseHelper();
  Client? client;
  bool isLoad = false;

  @override
  void initState() {
    getClient();
    super.initState();
  }

  getClient() async {
    client = await db.getClient(widget.client.id!);
    setState(() {
      isLoad = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    getClient();
    return Scaffold(
      appBar: AppBar(),
      body: !isLoad
    ?Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.white,
        size: 100,
      ),)
    :Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    width:120,
                    height: 90,
                    child: Icon(Icons.person, size: 80,),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                    Column(
                      children: [
                        TextView(tile: "Name", value: client!.name,),
                        TextView(tile: "Adress", value: client!.address,),
                        TextView(tile: "Lampes", value: client!.splitLamps().length.toString()),
                      ],
                    ),
                  SizedBox(height: 10,),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconAction(icon: Icons.edit, text: "Editer", func: () {}),
                    IconAction(icon: Icons.send, text: "Remettre", func: () async {
                      /* await db.deleteClient(widget.client);
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>Home(1)));*/
                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>QrCodeScanner(db: db, scan: giveBack)));
                    }),
                    IconAction(icon: Icons.add, text: "Ajouter", func: () {Navigator.push(context, MaterialPageRoute(builder: (builder) => QrCodeScanner(db: db, scan: scanLamp)));},),
                  ],
                ),
              ),
              Text("Lampes"),
              SizedBox(
                height: 2000,
                child: ListView.builder(
                  itemCount: client!.splitLamps().length,
                  itemBuilder: (context, index) {
                    return LampList(lampCode: client!.splitLamps()[index]);
                  }
                ),
              )
            ],
            mainAxisSize: MainAxisSize.max,
          ),
        ),
      ),
    );
  }

  Future giveBack(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    final client = await db.getClient(widget.client.id!);
    for (final barcode in barcodes) {
      var code = barcode.rawValue;
      if(code != null) {
        var isLamp = await db.getLamp(code);
        if (isLamp == null) {
          print("Lampe n'esxiste pas");
        }  else if (db.isLampForClient(client, code)){
          await db.giveBackLamp(code);
          print("Lampe est remise");
        }
        else {
          print("Lampe n'appartient pas à ce client");
        }
      }
      Navigator.pop(context);
    }
  }

  Future scanLamp(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      var code = barcode.rawValue;
      if(code != null) {
        var isLamp = await db.getLamp(code);
        if (isLamp == null) {
          Fluttertoast.showToast(msg: "Lampe n'esxiste pas", backgroundColor: Colors.red[200], toastLength: Toast.LENGTH_LONG);
        } else {
          if(isLamp.user == null) {
            var isLampAdd = await db.addClientLamps(client!, code);
            if (isLampAdd) {
              await widget.refreshListPersonPage();
              Fluttertoast.showToast(
                msg: "Lampe ${code} a été ajoutée à ${client?.name}",
                backgroundColor: Colors.green[200],
                toastLength: Toast.LENGTH_LONG);
            }
          } else {
            Fluttertoast.showToast(
                msg: "La lampe a déjà été distribuée",
                backgroundColor: Colors.red[200],
                toastLength: Toast.LENGTH_LONG);
          }
        }
      }
      await getClient();
      Navigator.pop(context);
    }
  }
}

class IconAction extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function func;
  const IconAction({
    super.key, required this.icon, required this.text, required this.func,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap:(){func();},
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Icon(icon),
            ),
            Text(text, style: const TextStyle(fontSize: 12),)
          ],
        ),
      ),
    );
  }
}

class TextView extends StatelessWidget {
  final String tile;
  final String value;
  const TextView({
    super.key, required this.tile, required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(tile, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 16))
        ],
      ),
    );
  }
}

class LampList extends StatefulWidget {
  final String lampCode;
  const LampList({super.key, required this.lampCode});

  @override
  State<LampList> createState() => _LampListState();
}

class _LampListState extends State<LampList> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(Icons.lightbulb_outline),
        title: Text(widget.lampCode),
      )
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String lampCode;
  const CustomDialog({super.key, required this.lampCode});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirmation"),
      content: Text("Cette lampe a - t - elle était remise ?"),
      actions: [
        TextButton(
            onPressed: () {
              print(lampCode);
            },
            child: Text("Oui")
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Non")
        ),
      ],
      actionsPadding: EdgeInsets.all(2),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
    );
  }
}




