import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lights/data/lamp.dart';
import 'package:lights/data/persons.dart';
import 'package:lights/database_services/helper.dart';
import 'package:lights/pages/list_lights.dart';
import 'package:lights/pages/list_person.dart';
import 'package:lights/qr_code/scanner.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Home extends StatefulWidget {
  int index;
  Home(this.index, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final db = DatabaseHelper();
  List<Widget> pages = [const ListLights(), ListPersons()];
  String? scanResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: pages,
        index: widget.index,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {
          setState(() {
            widget.index = index;
          });
        },
        currentIndex: widget.index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: "Lampes"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Clients"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(widget.index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (builder) => QrCodeScanner(db: db, scan: scanLamp,)));
          } else {
            showDialog(
              context: context,
              builder: (context) => CustomDialog(db: db,));
          }
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Theme.of(context).primaryColor,),
      ),
    );
  }
  void scanLamp(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      var code = barcode.rawValue;
      if(code != null) {
        try {
          await db.addLamp(Lamp(code: code, status: 0));
          Fluttertoast.showToast(msg: "La lampe a été enregistrée",
              backgroundColor: Colors.green[300], toastLength: Toast.LENGTH_LONG
          );
        } catch(e) {
          Fluttertoast.showToast(msg: "La lampe est déjà enregistrée",
            backgroundColor: Colors.red[300], toastLength: Toast.LENGTH_LONG
          );
        }
        Navigator.pop(context);
      }
    }
  }
}

class CustomDialog extends StatelessWidget {
  final db;
  const CustomDialog({super.key, this.db});

  @override
  Widget build(BuildContext context) {

    final nameClient = TextEditingController();
    final addressClient = TextEditingController();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          CardDialog(nameClient: nameClient, addressClient: addressClient, db: db,),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(60)
              ),
              child: InkWell(
                child: Icon(Icons.close, size: 20,),
                onTap: () {
                  nameClient.clear();
                  addressClient.clear();
                  Navigator.of(context).pop();
                },
              ),
            )
          )
        ],
      ),
    );
  }
}

class CardDialog extends StatelessWidget {
  final db;
  final nameClient;
  final addressClient;
  CardDialog({super.key, required this.nameClient, required this.addressClient, required this.db});

  final _formField = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Form(
        key: _formField,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Ajouter un client", style: TextStyle(fontSize: 20),),
              SizedBox(height: 30,),
              TextFormField(
                controller: nameClient,
                validator: (value) {
                  if(value!.isEmpty) {
                    return "Ce champ doit être rempli";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Nom ",
                  prefixIcon: Icon(Icons.person)
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: addressClient,
                validator: (value) {
                  if(value!.isEmpty) {
                    return "Ce champ doit être rempli";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Address ",
                  prefixIcon: Icon(Icons.map)
                ),
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: () async {
                  if(_formField.currentState!.validate()) {
                    await db.addClient(Client(name: nameClient.text, address: addressClient.text, lamps: null));
                    nameClient.clear();
                    addressClient.clear();
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>Home(1)));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Text("Enregistrer", textAlign: TextAlign.center,),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}

