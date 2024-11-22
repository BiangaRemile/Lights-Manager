import 'package:flutter/material.dart';
import 'package:lights/assets.dart';
import 'package:lights/data/lamp.dart';
import 'package:lights/data/persons.dart';
import 'package:lights/pages/details/client.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../database_services/helper.dart';

class ListLights extends StatefulWidget {
  const ListLights({super.key});

  @override
  State<ListLights> createState() => _ListLightsState();
}

class _ListLightsState extends State<ListLights> {

  final DatabaseHelper db = DatabaseHelper();

  List<Lamp>? lights;
  bool load = false;

  @override
  void initState() {
    getlights();
    super.initState();
  }

  void getlights() async {
    lights = await db.getLamps();
    if (lights != null) {setState(() {load = true;});}
  }

  @override
  Widget build(BuildContext context) {
    getlights();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: !load
        ? Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 200,
          ),
        )
        :GridView.builder(
          itemCount: lights!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.5,
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (BuildContext context, int index){

            return InkWell(
              child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset(lampImage, width: 60,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(lights![index].code, style: TextStyle(fontSize: 16),),
                            const SizedBox(height: 5,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: lights![index].status == 0? Colors.green[50]: Colors.red[50],
                                  border: Border.all(
                                      width: 2,
                                      color: lights![index].status == 0? Colors.green: Colors.red
                                  )
                              ),
                              child: Text(lights![index].status == 0? "Disponiple": "Indisponible", style: TextStyle(color: Colors.grey),),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () async {
                  Client? client;
                  if (lights![index].status == 1) {
                     client = await db.getClient(lights![index].user!);
                  }
                  showDialog(
                    context: context,
                    builder: (builder) => DialogCard(lamp: lights![index], client: client, db: db,));
              },
            );
          },
        ),
      ),
    );
  }
}


class DialogCard extends StatelessWidget {
  final Lamp lamp;
  final Client? client;
  final DatabaseHelper db;
  const DialogCard({super.key, required this.lamp, required this.client, required this.db});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          LightCard(lamp: lamp, client: client, db: db,)
        ],
      ),
    );
  }
}

class LightCard extends StatelessWidget {
  final Lamp lamp;
  final Client? client;
  final DatabaseHelper db;
  const LightCard({super.key, required this.lamp, required this.client, required this.db});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 10, right: 8, left: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(lamp.code),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ]
          ),
          QrImageView(
            data: lamp.code,
            size: 200,
          ),
          ElevatedButton.icon(
              onPressed: () async {
                await db.deleteLamp(lamp);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
              label: const Text("Supprimer")),
          Container(
            width: client != null? null: double.infinity ,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            padding: client != null? EdgeInsets.symmetric(horizontal: 10): EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10)
            ),
            child: client != null 
                ?Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(lamp.toStringDate()),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (builder) => ClientDetails(client: client!, refreshListPersonPage: (){})));
                      },
                      child: Text(client!.name)
                  )
              ],
            )
            : const Text("Lampe disponible", textAlign: TextAlign.center, style: TextStyle(color: Colors.green),)
          ),
        ],
      ),
    );
  }
}

