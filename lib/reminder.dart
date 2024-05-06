import 'package:flutter/material.dart';
import 'package:talacare/components/button.dart';
import 'package:talacare/helpers/color_palette.dart';
import 'package:talacare/helpers/text_styles.dart';
import 'package:talacare/reminder_create.dart';
import 'package:talacare/reminder_schedule.dart';

class Reminder extends StatelessWidget {
  Reminder();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: AppColors.blue,
        appBar: AppBar(
          backgroundColor: AppColors.blue,
          title: Text("Pengingat Minum Obat", style: AppTextStyles.h2,),
          centerTitle: true,
          leading: IconButton(
              icon: Image.asset('assets/images/Dialog/home.png'),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: ScheduleList(),
              ),
              CustomButton(
                text: 'Buat Jadwal Baru',
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ReminderCreateForm();
                  },
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
            ],
          ),
        ));
  }
}
