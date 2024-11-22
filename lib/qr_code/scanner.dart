import 'package:flutter/material.dart';
import 'package:lights/database_services/helper.dart';
import 'package:lights/pages/home.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  final Function scan;
  final DatabaseHelper db;
  const QrCodeScanner({super.key, required this.db, required this.scan});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {

  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: controller,
        onDetect: (BarcodeCapture capture) {
          widget.scan(capture);
          controller.stop();
        }
    )
    );
  }
}