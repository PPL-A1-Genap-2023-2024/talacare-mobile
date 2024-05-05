import 'package:flutter/material.dart';
import 'package:talacare/reminder_create.dart';
import 'package:talacare/reminder_schedule.dart';

class Reminder extends StatelessWidget {
  Reminder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminder Obat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ScheduleList(),
          ),
          ElevatedButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return ReminderCreateForm();
              },
            ),
            child: const Text('Tambahkan Jadwal Baru'),
          )
        ],
      ),
    );
  }
}
