import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQR extends StatefulWidget {
  final Function(Barcode)? onQrCode;

  const ScanQR({Key? key, this.onQrCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final qrViewKey = GlobalKey(debugLabel: "QR");
  QRViewController? qrController;

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await qrController?.pauseCamera();
    }
    await qrController?.resumeCamera();
  }

  @override
  dispose() {
    qrController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Scan QR Code"),
            titleTextStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
        body: QRView(
          key: qrViewKey,
          onQRViewCreated: (controller) {
            setState(() {
              qrController = controller;
            });

            controller.scannedDataStream.first.then((barcode) {
              if (widget.onQrCode != null) widget.onQrCode!(barcode);
              Future.delayed(Duration.zero, () {
                Navigator.of(context).pop();
              });
            });
          },
          overlay: QrScannerOverlayShape(
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
              borderWidth: 12,
              borderLength: 24,
              borderRadius: 8,
              borderColor: Colors.deepPurple),
        ));
  }
}
