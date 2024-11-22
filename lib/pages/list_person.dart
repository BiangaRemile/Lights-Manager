import 'package:flutter/material.dart';
import 'package:lights/data/persons.dart';
import 'package:lights/pages/details/client.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../database_services/helper.dart';

class ListPersons extends StatefulWidget {

  const ListPersons({super.key});

  @override
  State<ListPersons> createState() => _ListPersonsState();
}

class _ListPersonsState extends State<ListPersons> {

  final db = DatabaseHelper();
  List<Client>? clients;
  bool load = false;

  @override
  void initState() {
    getClients();
    super.initState();
  }

  getClients() async {
    var getClients = await db.getClients();
    clients = getClients;
    setState(() {
      load = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    getClients();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: !load
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 200,
            ),)
        :ListView.builder(
        itemCount: clients!.length,
        itemBuilder: (BuildContext context, int index) {
            return ClientItem(client: clients![index], reload: getClients,);
          }
        )
      )
    );
  }
}

class ClientItem extends StatefulWidget {
  final Client client;
  final Function reload;
  const ClientItem({super.key, required this.client, required this.reload});

  @override
  State<ClientItem> createState() => _ClientItemState();
}

class _ClientItemState extends State<ClientItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child: ListTile(
        leading: Container(
          margin: const EdgeInsets.only(right: 16),
          width: 40,
          height: 40,
          child: Icon(Icons.person),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).primaryColor
          ),
        ),
        title: Text(widget.client.name),
        subtitle: Text(widget.client.address),
        trailing: Container(
          width: 40,
          child: Row(
            children: [
              Text(widget.client.splitLamps().length.toString(), style: TextStyle(fontSize: 14),),
              const Icon(Icons.lightbulb)
            ],
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => ClientDetails(client: widget.client, refreshListPersonPage: widget.reload,)));
        },
      )
    );
  }
}

