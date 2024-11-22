import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerQR extends StatefulWidget {
  final Function scan;
  const ScannerQR({super.key, required this.scan});

  @override
  State<ScannerQR> createState() => _ScannerQRState();
}

class _ScannerQRState extends State<ScannerQR> {
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container()
            ),
            Expanded(
              flex: 3,
              child: Container()
            ),
            Expanded(
              flex: 1,
              child: Container()
            ),
          ],
        ),
    );
  }
}
