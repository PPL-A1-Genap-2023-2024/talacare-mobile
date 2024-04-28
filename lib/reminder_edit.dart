import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talacare/reminder.dart';
import 'package:talacare/schedule_util.dart';

class ReminderEditForm extends StatefulWidget {
  final int currentHour;
  final int currentMinute;
  final int id;

  ReminderEditForm({
    Key? key,
    required this.currentHour,
    required this.currentMinute,
    required this.id,
  }) : super(key: key);

  @override
  State<ReminderEditForm> createState() => _ReminderEditFormState();
}

class _ReminderEditFormState extends State<ReminderEditForm> {
  final _formKey = GlobalKey<FormState>();
  late int currentHour;
  late int currentMinute;
  late int id;
  late TimeOfDay schedule = TimeOfDay(hour: currentHour, minute: currentMinute);
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    currentHour = widget.currentHour;
    currentMinute = widget.currentMinute;
    id = widget.id;
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _selectSchedule(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: schedule,
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (picked != null && picked != schedule) {
      setState(() {
        schedule = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Ubah Jadwal',
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(schedule.toString()),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () => _selectSchedule(context),
                child: const Text('Pilih Waktu'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final response =
                        editSchedule(schedule.hour, schedule.minute, id, prefs);
                    if (response == "Berhasil mengubah jadwal") {
                      Navigator.pop(context);
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
                  child: const Text("Ubah Jadwal"))
            ],
          ),
        ),
      ),
    );
  }
}
