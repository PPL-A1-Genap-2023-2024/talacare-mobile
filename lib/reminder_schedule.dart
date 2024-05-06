import 'package:flutter/material.dart';
import 'package:talacare/components/button.dart';
import 'package:talacare/helpers/color_palette.dart';
import 'package:talacare/helpers/text_styles.dart';
import 'package:talacare/reminder.dart';
import 'package:talacare/reminder_edit.dart';
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
    SharedPreferences.getInstance().then((prefsInstance) => setState(() {
          prefs = prefsInstance;
        }));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (prefs == null) {
      return CircularProgressIndicator();
    } else {
      var scheduleList = fetchSchedule(prefs!);
      if (scheduleList.isEmpty) {
        return Text(
          "Kamu Belum Membuat Jadwal Pengingat",
          style: AppTextStyles.h1,
        );
      }

      return Container(
          constraints: BoxConstraints(maxWidth: screenWidth * 0.88),
          child: ListView.separated(
            itemCount: scheduleList.length,
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(height: screenHeight * 0.03),
            itemBuilder: (context, index) {
              final schedule = scheduleList[index][0];
              var hourText =
                  schedule.hour % 12 != 0 ? ("${schedule.hour % 12}") : ("12");
              var minuteText = schedule.minute < 10
                  ? "0${schedule.minute}"
                  : "${schedule.minute}";
              var suffix = schedule.hour < 12 ? "AM" : "PM";

              return Container(
                  decoration: BoxDecoration(
                      color: AppColors.baseColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.plum, width: 6)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      Text(
                        '$hourText:$minuteText $suffix',
                        style: AppTextStyles.h1,
                      ),
                      SizedBox(
                        height: screenHeight * 0.015,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomButton(
                            text: "Ubah",
                            size: ButtonSize.small,
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return ReminderEditForm(
                                  currentHour: schedule.hour,
                                  currentMinute: schedule.minute,
                                  id: scheduleList[index][1],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.04,
                          ),
                          CustomButton(
                            text: "Hapus",
                            size: ButtonSize.small,
                            onPressed: () async {
                              final response = deleteSchedule(
                                  scheduleList[index][1], prefs!);
                              if (response == "Berhasil menghapus jadwal") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Reminder()),
                                );
                              }
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(response),
                                duration: Duration(seconds: 2),
                              ));
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                    ],
                  ));
            },
          ));
    }
  }
}
