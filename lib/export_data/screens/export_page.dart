import 'package:flutter/material.dart';

class ExportPage extends StatefulWidget {
  ExportPage({Key? key}) : super(key: key);

  final GlobalKey _backButtonKey = GlobalKey();
  final GlobalKey _downloadButtonKey = GlobalKey();

  GlobalKey getBackButtonKey() {
    return _backButtonKey;
  }

  GlobalKey getDownloadButtonKey() {
    return _downloadButtonKey;
  }

  @override
  State<ExportPage> createState() => _ExportPageState(
      backButtonKey: _backButtonKey, downloadButtonKey: _downloadButtonKey);
}

class _ExportPageState extends State<ExportPage> {
  final GlobalKey backButtonKey;
  final GlobalKey downloadButtonKey;
  _ExportPageState(
      {required this.backButtonKey, required this.downloadButtonKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD7A9EC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mengunduh Data Pemain',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            Container(
                child: Column(
              children: [
                Text(
                  'Tekan tombol Export Data untuk mengunduh',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                IconButton(
                  icon: Image.asset("assets/images/Button/ExportButton.png"),
                  key: downloadButtonKey,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Image.asset("assets/images/Button/BackButton.png"),
                  key: backButtonKey,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
