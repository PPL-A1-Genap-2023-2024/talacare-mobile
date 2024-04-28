import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talacare/reminder.dart';
import 'package:talacare/schedule_util.dart';

class ReminderCreateForm extends StatefulWidget {
  ReminderCreateForm({super.key});

  @override
  State<ReminderCreateForm> createState() => _ReminderCreateFormState();
}

class _ReminderCreateFormState extends State<ReminderCreateForm> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay schedule = TimeOfDay(hour: 0, minute: 0);
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
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
            'Buat Jadwal Baru',
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
                        addSchedule(schedule.hour, schedule.minute, prefs);
                    if (response == "Berhasil membuat jadwal") {
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
                  child: const Text("Buat Jadwal"))
            ],
          ),
        ),
      ),
    );
  }
}
