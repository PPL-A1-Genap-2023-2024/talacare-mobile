import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:talacare/reminder.dart';

class ReminderEditForm extends StatefulWidget {
  final int currentHour;
  final int currentMinute;
  final int id;
  final http.Client httpClient;

  const ReminderEditForm(
      {Key? key,
      required this.currentHour,
      required this.currentMinute,
      required this.id,
      required this.httpClient})
      : super(key: key);

  @override
  State<ReminderEditForm> createState() => _ReminderEditFormState();
}

class _ReminderEditFormState extends State<ReminderEditForm> {
  final _formKey = GlobalKey<FormState>();
  late int currentHour;
  late int currentMinute;
  late int id;
  late http.Client httpClient;
  late TimeOfDay schedule = TimeOfDay(hour: currentHour, minute: currentMinute);

  @override
  void initState() {
    super.initState();
    currentHour = widget.currentHour;
    currentMinute = widget.currentMinute;
    id = widget.id;
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
                    //TODO: Possibly refactor this and django backend to use json instead of from data
                    final response = await httpClient.post(
                        Uri.parse('http://localhost:8000/reminder/edit/${id}'),
                        headers: <String, String>{
                          'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: <String, String>{
                          "hour": schedule.hour.toString(),
                          "minute": schedule.minute.toString(),
                        });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Reminder(httpClient)),
                    );
                  },
                  child: const Text("Ubah Jadwal"))
            ],
          ),
        ),
      ),
    );
  }
}
