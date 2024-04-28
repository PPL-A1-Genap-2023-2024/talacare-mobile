import 'dart:async';
import 'package:flutter/material.dart';
import 'package:talacare/reminder.dart';
import 'package:talacare/reminder_create.dart';
import 'package:talacare/reminder_edit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talacare/schedule_util.dart';

class ScheduleList extends StatefulWidget {
  ScheduleList({super.key});

  @override
  ScheduleListState createState() => ScheduleListState();
}

class ScheduleListState extends State<ScheduleList> {
  SharedPreferences? prefs;

  ScheduleListState() {
    SharedPreferences.getInstance().then((prefs_instance) => setState(() {
          prefs = prefs_instance;
        }));
  }

  @override
  Widget build(BuildContext context) {
    var schedule_list = fetchSchedule(prefs!);

    return ListView.builder(
      itemCount: schedule_list.length,
      itemBuilder: (context, index) {
        final schedule = schedule_list[index];
        return ListTile(
          title: Text('ID: ${index + 1}'),
          subtitle: Text('Time: ${schedule.hour}:${schedule.minute}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ReminderEditForm(
                      currentHour: schedule.hour,
                      currentMinute: schedule.minute,
                      id: index + 1,
                    );
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  final response = deleteSchedule(index + 1, prefs!);
                  if (response == "Berhasil menghapus jadwal") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Reminder()),
                    );
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(response),
                    duration: Duration(seconds: 2),
                  ));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
