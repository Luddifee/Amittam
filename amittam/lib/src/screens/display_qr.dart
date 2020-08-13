import 'package:Amittam/src/libs/uilib.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DisplayQr extends StatefulWidget {
  DisplayQr(this.data);
  final String data;
  @override
  _DisplayQrState createState() => _DisplayQrState();
}

class _DisplayQrState extends State<DisplayQr> {
  bool usesNormalTheme = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context)),
        elevation: 0,
        title: Text('Display QR', style: TextStyle(fontSize: 25, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(30),
          child: QrImage(
            data: widget.data,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
