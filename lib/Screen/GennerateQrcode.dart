import 'package:flutter/material.dart';

class GenQR extends StatefulWidget {
  const GenQR({super.key});

  @override
  State<GenQR> createState() => _GenQRState();
}

class _GenQRState extends State<GenQR> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Gen QR'),
    );
  }
}