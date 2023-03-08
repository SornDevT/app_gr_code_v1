import 'package:flutter/material.dart';

import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:scan/scan.dart';
import 'package:images_picker/images_picker.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  /// image Scan

  ScanController controller_img = ScanController();
  String _platformVersion = 'ບໍ່ຮູ້ຈັກ..';

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = "ບໍ່ສາມາດກວດຊອບ Platform Version ໄດ້!";
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  //--------------------------
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? RBarcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQRView(context),
          Positioned(
            top: 10,
            child: Text(
              'Platfrom: ${_platformVersion}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Positioned(
            top: 30,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {});
                  },
                  child: FutureBuilder(
                    future: controller?.getFlashStatus(),
                    builder: (context, snapshot) {
                      return Text('ເປີດ Flash: ${snapshot.data}');
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await controller?.flipCamera();
                    setState(() {});
                  },
                  child: FutureBuilder(
                    future: controller?.getCameraInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return Text(
                            'ເປີດກ້ອງ: ${describeEnum(snapshot.data!)}');
                      } else {
                        return Text('ກຳລັງໂຫຼດ...');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(bottom: 40, child: _buildResult())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<Media>? res = await ImagesPicker.pick();
          if (res != null) {
            String? str = await Scan.parse(res[0].path);
            if (str != null) {
              setState(() {
                RBarcode = str;
              });
            }
          }
        },
        child: const Icon(Icons.image_search),
      ),
    );
  }

  // ສ້າງ widget ສະແດງຜົນລັບ QR Code
  Widget _buildResult() => InkWell(
        onTap: () async {
          await controller?.resumeCamera();
          print('Scan!!');
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            RBarcode != null ? 'Data: ${RBarcode}' : 'ກົດເພື່ອສະແກນ Code!',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  /// ສ້າງ widget ສະແກນ QR Code / Barcode
  Widget buildQRView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: qrViewCreate,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 20,
          borderLength: 40,
          borderWidth: 10,
        ),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );

  // ຟັງຊັ່ນ ສິດການເຂົ້າເຖິງ ກ້ອງ
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ທ່ານ ບໍ່ມີສິດເຂົ້າເຖິງກ້ອງຖ່ານຮູບ')),
      );
    }
  }

  // ຟັງຊັ່ນ ສ້າງໂຕສະແກນ
  void qrViewCreate(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        RBarcode = barcode.code;
      });
    });
  }
}
