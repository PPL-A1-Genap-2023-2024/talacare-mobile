import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:talacare/config.dart';
import 'package:talacare/helpers/color_palette.dart';
import 'package:talacare/helpers/text_styles.dart';

class ExportPage extends StatefulWidget {
  ExportPage({Key? key, http.Client? client, String? recipientEmail})
      : client = client ?? http.Client(),
        recipientEmail = recipientEmail ?? '',
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
    Uri url = Uri.parse('$urlBackEnd/export/send_email/');
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
            style: AppTextStyles.h2,
          ),
          actions: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Silakan periksa inbox email anda",
                    textAlign: TextAlign.center, style: AppTextStyles.normal),
                IconButton(
                  icon: Image.asset("assets/images/Button/BackButton.png"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mengekspor Data Pemain',
              style: AppTextStyles.h1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              child: Column(
                children: [
                  Text(
                    'Tekan tombol Export Data untuk mengirim data pemain melalui email',
                    style: AppTextStyles.normal,
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
