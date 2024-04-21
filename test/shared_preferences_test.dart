import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talacare/shared_preferences_util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Schedule Functions', () {
    test('Adding a schedule', () async {
      String result = await addSchedule(8, 30);
      expect(result, "Berhasil membuat jadwal");
    });

    test('Fetching schedule', () async {
      await addSchedule(9, 45);
      await addSchedule(12, 0);
      await addSchedule(15, 30);

      List schedule = await fetchSchedule();
      expect(schedule.length, 3);
    });

    test('Editing a schedule', () async {
      await addSchedule(10, 15);

      String result = await editSchedule(11, 30, 1);
      expect(result, "Berhasil mengubah jadwal");

      List schedule = await fetchSchedule();
      expect(schedule.length, 1);
      expect(schedule[0].hour, 11);
      expect(schedule[0].minute, 30);
    });

    test('Deleting a schedule', () async {
      await addSchedule(8, 0);

      String result = await deleteSchedule(1);
      expect(result, "Berhasil menghapus jadwal");

      List schedule = await fetchSchedule();
      expect(schedule.length, 0);
    });
  });
}
