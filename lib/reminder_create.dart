import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:talacare/reminder.dart';

class ReminderCreateForm extends StatefulWidget {
  final http.Client httpClient;

  const ReminderCreateForm({super.key, required this.httpClient});

  @override
  State<ReminderCreateForm> createState() => _ReminderCreateFormState();
}

class _ReminderCreateFormState extends State<ReminderCreateForm> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay schedule = TimeOfDay(hour: 0, minute: 0);
  late http.Client httpClient;

  @override
  void initState() {
    super.initState();
    httpClient = widget.httpClient;
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
                    //TODO: Possibly refactor this and django backend to use json instead of from data
                    final response = await httpClient.post(
                        Uri.parse('http://localhost:8000/reminder/create'),
                        headers: <String, String>{
                          'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: <String, String>{
                          "hour": schedule.hour.toString(),
                          "minute": schedule.minute.toString(),
                        });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Reminder(httpClient)),
                    );
                  },
                  child: const Text("Buat Jadwal"))
            ],
          ),
        ),
      ),
    );
  }
}
