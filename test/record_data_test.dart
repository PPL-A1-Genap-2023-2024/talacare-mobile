import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:talacare/config.dart';
import 'package:talacare/helpers/data_sender.dart';
import 'package:talacare/talacare.dart';
import 'package:http/http.dart' as http;
import 'export_data_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Timestamp Functionality Test', () {
    testWithGame<TalaCare>('Check Start and End Timestamp', TalaCare.new,
        (game) async {
      await game.ready();
      game.update(1000);
      game.victory();
      expect(game.totalTime, greaterThan(0));
      expect(game.haveSentRecap, true);
    });
    testWithGame<TalaCare>('Check Time When The Game is Paused', TalaCare.new,
        (game) async {
      await game.ready();
      game.lifecycleStateChange(AppLifecycleState.paused);
      game.lifecycleStateChange(AppLifecycleState.hidden);
      game.update(1000);
      expect(game.paused, true);
      int timeNow = game.totalTime;
      game.update(1000);
      expect(game.totalTime, timeNow);
      game.lifecycleStateChange(AppLifecycleState.resumed);
      expect(game.paused, false);
    });
    testWidgets('Send Data Test', (WidgetTester tester) async {
      Uri uriExample = Uri.parse('$urlBackEnd/export/upload_player_data/');
      MockClient client = MockClient();
      await sendData(client: client, email: '', totalTime: 10000);
      verify(client.post(
        uriExample,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: anyNamed('body'),
      )).called(1);
    });
    test('Function formatMilliseconds Test', () {
      expect(formatMilliseconds(0), equals('00:00:00'));
      expect(formatMilliseconds(1000), equals('00:00:01'));
      expect(formatMilliseconds(10000), equals('00:00:10'));
      expect(formatMilliseconds(60000), equals('00:01:00'));
      expect(formatMilliseconds(3600000), equals('01:00:00'));
      expect(formatMilliseconds(3661000), equals('01:01:01'));
    });
    test('Function formatDateTime Test', () {
      expect(formatDateTime(DateTime(2024, 5, 5)), equals('2024-5-5'));
      expect(formatDateTime(DateTime(2023, 12, 31)), equals('2023-12-31'));
      expect(formatDateTime(DateTime(2024, 2, 29)), equals('2024-2-29'));
    });
  });
}
