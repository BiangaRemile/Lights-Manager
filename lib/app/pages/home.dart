import 'package:flutter/material.dart';
import 'package:lights/app/pages/clients.dart';
import 'package:lights/app/pages/lights.dart';
import 'package:lights/app/qr_code/scanner.dart';

class HOME extends StatefulWidget {
  const HOME({super.key});

  @override
  State<HOME> createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {

  int indexPage = 0;
  List <Widget> pages = [const ClientsPage(), ScannerQR(scan: () {}), const LightsPage()];

  @override
  Widget build(BuildContext context) {

    Color primary = Theme.of(context).primaryColor;

    return Scaffold(
      body: IndexedStack(
        children: pages,
        index: indexPage,
      ),
      backgroundColor: primary,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 30,
        iconSize: 40,
        selectedItemColor: Colors.purple,
        backgroundColor: Colors.white,
        currentIndex: indexPage,
        onTap: (index) => setState(() {
          indexPage = index;
        }),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Clients"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: "Scanner"),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: "Lampes"),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.purple,
            ),
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
