import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talacare/components/button.dart';
import 'package:talacare/helpers/color_palette.dart';
import 'package:talacare/helpers/text_styles.dart';
import 'package:talacare/screens/reminder.dart';
import 'package:talacare/helpers/schedule_util.dart';

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
    double screenHeight = MediaQuery.of(context).size.height;
    var hourText = schedule.hour % 12 != 0 ? ("${schedule.hour % 12}") : ("12");
    var minuteText =
        schedule.minute < 10 ? "0${schedule.minute}" : "${schedule.minute}";
    var suffix = schedule.hour < 12 ? "AM" : "PM";

    return Scaffold(
      backgroundColor: AppColors.greenPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.greenPrimary,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Buat Jadwal Baru',
            style: AppTextStyles.h1,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Center(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: AppColors.baseColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.plum, width: 8)),
                padding: EdgeInsets.all(9),
                child: Column(
                  children: [
                    Text(
                      "Waktu Pilihan:",
                      style: AppTextStyles.h1,
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Text(
                      '$hourText:$minuteText $suffix',
                      style: AppTextStyles.h1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              CustomButton(
                onPressed: () => _selectSchedule(context),
                text: 'Pilih Waktu',
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              CustomButton(
                text: "Ubah Jadwal",
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
              )
            ],
          ),
        )),
      ),
    );
  }
}
