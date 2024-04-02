import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:talacare/models/schedule.dart';
import 'package:talacare/reminder_create.dart';
import 'package:talacare/reminder_schedule.dart';

Future<List<Schedule>> fetchSchedule(http.Client httpClient) async {
  final response = await httpClient.get(
    Uri.parse('http://localhost:8000/reminder/show'),
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final List<dynamic> scheduleJsonList = jsonData['schedule'];

    final List<Schedule> scheduleList = scheduleJsonList
        .map((scheduleJson) => Schedule.fromJson(scheduleJson))
        .toList();

    return scheduleList;
  } else {
    throw Exception('Gagal mendapatkan jadwal: ${response.statusCode}');
  }
}

class Reminder extends StatelessWidget {
  final http.Client httpClient;
  Reminder(this.httpClient);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminder Obat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ScheduleList(httpClient),
          ),
          ElevatedButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return ReminderCreateForm(httpClient: httpClient);
              },
            ),
            child: const Text('Tambahkan Jadwal Baru'),
          ),
        ],
      ),
    );
  }
}
