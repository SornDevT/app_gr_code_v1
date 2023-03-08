import 'package:flutter/material.dart';

import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            child: Text('Platfrom:'),
          ),
          Positioned(
            top: 30,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('ເປີດ Flash'),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('ເປີດກ້ອງໜ້າ'),
                ),
              ],
            ),
          ),
          Positioned(bottom: 40, child: Text('data'))
        ],
      ),
    );
  }
}
