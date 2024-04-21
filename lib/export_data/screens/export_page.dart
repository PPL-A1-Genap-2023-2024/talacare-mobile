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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mengunduh Data Pemain',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
                child: Column(
              children: [
                Text(
                  'Tuliskan nama file yang akan diunduh',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'talacare_data',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  key: downloadButtonKey,
                  onPressed: () {},
                  child: Text('Unduh'),
                ),
                ElevatedButton(
                  key: backButtonKey,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Kembali'),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
