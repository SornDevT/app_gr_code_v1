import 'package:flutter/material.dart';

import 'GennerateQrcode.dart';
import 'ScanGrcode.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _seclectPage = 0;

  static const List _Page = [
    ScanQR(),
    GenQR(),
  ];

  void _onItemPage(int index) {
    setState(() {
      _seclectPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App QR Code'),
      ),
      body: _Page[_seclectPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _seclectPage,
        onTap: _onItemPage,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: 'ສະແກນ QR Code'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code), label: 'ສ້າງ QR Code'),
        ],
      ),
    );
  }
}
