import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:talacare/models/schedule.dart';
import 'package:talacare/reminder.dart';
import 'package:talacare/reminder_create.dart';
import 'package:talacare/reminder_edit.dart';
import 'package:http/http.dart' as http;

class ScheduleList extends StatelessWidget {
  final http.Client httpClient;
  const ScheduleList(this.httpClient);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Schedule>>(
      future: fetchSchedule(httpClient),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final schedule = snapshot.data![index];
              return ListTile(
                title: Text('ID: ${schedule.id}'),
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
                            id: schedule.id,
                            httpClient: httpClient,
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        //TODO: Possibly refactor this and django backend to use json instead of from data
                        final response = await httpClient.delete(
                          Uri.parse(
                              'http://localhost:8000/reminder/delete/${schedule.id}'),
                          headers: <String, String>{
                            'Content-Type': 'application/x-www-form-urlencoded'
                          },
                        );
                        final Map<String, dynamic> responseBody =
                            jsonDecode(response.body);
                        if (response.statusCode == 200) {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Reminder(httpClient)),
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text(responseBody['message']), // Snackbar message
                          duration: Duration(
                              seconds:
                                  2), // Duration for which the Snackbar will be displayed
                        ));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }
}
