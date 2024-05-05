import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:talacare/config.dart';

class ExportPage extends StatefulWidget {
  ExportPage({Key? key, http.Client? client, String recipientEmail = ''})
      : client = client ?? http.Client(),
        recipientEmail = recipientEmail,
        super(key: key);

  final GlobalKey _backButtonKey = GlobalKey();
  final GlobalKey _downloadButtonKey = GlobalKey();
  final http.Client client;
  final String recipientEmail;

  GlobalKey getBackButtonKey() {
    return _backButtonKey;
  }

  GlobalKey getDownloadButtonKey() {
    return _downloadButtonKey;
  }

  @override
  State<ExportPage> createState() => _ExportPageState(
      backButtonKey: _backButtonKey,
      downloadButtonKey: _downloadButtonKey,
      client: client,
      recipientEmail: recipientEmail);
}

class _ExportPageState extends State<ExportPage> {
  final GlobalKey backButtonKey;
  final GlobalKey downloadButtonKey;
  final http.Client client;
  final String recipientEmail;

  _ExportPageState({
    required this.backButtonKey,
    required this.downloadButtonKey,
    required this.client,
    required this.recipientEmail,
  });

  Future<void> fetchData(http.Client client, BuildContext context) async {
    Uri url = Uri.parse(urlBackEnd + '/export/send_email/');
    try {
      http.Response response = await client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'recipient_email': recipientEmail,
        }),
      );
      if (response.statusCode == 200) {
        showDialogMessage(context, "Berhasil Export Data");
      } else {
        showDialogMessage(context, "Gagal Export Data");
      }
    } catch (e) {
      showDialogMessage(context, "Gagal Export Data");
    }
  }

  void showDialogMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'sans-serif'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset("assets/images/Button/BackButton.png"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD7A9EC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mengekspor Data Pemain',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sans-serif'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              child: Column(
                children: [
                  Text(
                    'Tekan tombol Export Data untuk mengirim data pemain melalui email',
                    style: TextStyle(fontSize: 15, fontFamily: 'sans-serif'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  IconButton(
                    icon: Image.asset("assets/images/Button/ExportButton.png"),
                    key: downloadButtonKey,
                    onPressed: () {
                      fetchData(client, context);
                    },
                  ),
                  IconButton(
                    icon: Image.asset("assets/images/Button/BackButton.png"),
                    key: backButtonKey,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
