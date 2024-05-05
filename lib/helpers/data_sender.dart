import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talacare/config.dart';

Future<void> sendData(
    {http.Client? client,
    required String email,
    required int totalTime}) async {
  client ??= http.Client();
  Uri url = Uri.parse('$urlBackEnd/export/upload_player_data/');
  String date = formatDateTime(DateTime.now());
  String duration = formatMilliseconds(totalTime);
  try {
    await client.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'email': email, 'date': date, 'duration': duration}),
    );
  } catch (e) {}
}

String formatMilliseconds(int milliseconds) {
  Duration duration = Duration(milliseconds: milliseconds);
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  String hoursStr = hours.toString().padLeft(2, '0');
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = seconds.toString().padLeft(2, '0');

  return "$hoursStr:$minutesStr:$secondsStr";
}

String formatDateTime(DateTime dateTime) {
  return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
}
