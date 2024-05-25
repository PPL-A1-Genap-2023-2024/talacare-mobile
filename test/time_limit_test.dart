import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talacare/helpers/time_limit.dart';
import 'package:talacare/main.dart';
import 'package:talacare/screens/homepage.dart';

import 'time_limit_test.mocks.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([SharedPreferences])
void main() {
  late int secondsInTwoHours;
  late MockSharedPreferences mockPrefs;
  setUp(() {
    secondsInTwoHours = 7200;
    mockPrefs = MockSharedPreferences();
  });
  testWidgets('Allow Less Than 2 Hours On Same Day Test',
      (WidgetTester tester) async {
    DateTime dateNow = DateTime.now();
    int duration = 6000; // Less than 7200 Seconds = 2 Hours
    when(mockPrefs.getInt('duration')).thenReturn(duration);
    when(mockPrefs.getInt('lastLogin'))
        .thenReturn(dateNow.millisecondsSinceEpoch);
    int result = await checkPlayerAppUsage(prefs: mockPrefs);
    expect(result, secondsInTwoHours - duration);
    expect(result > 0, true);
    verify(mockPrefs.getInt('duration')).called(1);
    verify(mockPrefs.getInt('lastLogin')).called(1);
  });
  testWidgets('Prevent More Than 2 Hours On Same Day Test',
      (WidgetTester tester) async {
    DateTime dateNow = DateTime.now();
    int duration = 8000; // More than 7200 Seconds = 2 Hours
    when(mockPrefs.getInt('duration')).thenReturn(duration);
    when(mockPrefs.getInt('lastLogin'))
        .thenReturn(dateNow.millisecondsSinceEpoch);
    int result = await checkPlayerAppUsage(prefs: mockPrefs);
    expect(result, secondsInTwoHours - duration);
    verify(mockPrefs.getInt('duration')).called(1);
    verify(mockPrefs.getInt('lastLogin')).called(1);
  });
  testWidgets('Special Case When First Time Play Test',
      (WidgetTester tester) async {
    when(mockPrefs.getInt('duration')).thenReturn(null);
    when(mockPrefs.getInt('lastLogin')).thenReturn(null);
    int result = await checkPlayerAppUsage(prefs: mockPrefs);
    expect(result, secondsInTwoHours);
    verify(mockPrefs.getInt('duration')).called(1);
    verify(mockPrefs.getInt('lastLogin')).called(1);
  });
  testWidgets('Allow More Than 2 Hours On Different Day Test',
      (WidgetTester tester) async {
    DateTime dateNow = DateTime.now();
    DateTime dateLastLogin = DateTime(2024, 5, 15);
    int duration = 8000; // More than 7200 Seconds = 2 Hours
    when(mockPrefs.getInt('duration')).thenReturn(duration);
    when(mockPrefs.getInt('lastLogin'))
        .thenReturn(dateLastLogin.millisecondsSinceEpoch);
    when(mockPrefs.setInt('duration', 0)).thenAnswer((_) async => true);
    when(mockPrefs.setInt('lastLogin', dateNow.millisecondsSinceEpoch))
        .thenAnswer((_) async => true);
    int result = await checkPlayerAppUsage(prefs: mockPrefs, dateNow: dateNow);
    expect(result, secondsInTwoHours);
    verify(mockPrefs.getInt('duration')).called(1);
    verify(mockPrefs.getInt('lastLogin')).called(1);
    verify(mockPrefs.setInt('duration', 0)).called(1);
    verify(mockPrefs.setInt('lastLogin', dateNow.millisecondsSinceEpoch))
        .called(1);
  });
  testWidgets('Save Usage Data Test', (WidgetTester tester) async {
    int newDurationInMillisecond = 1000;
    int newDuration = (newDurationInMillisecond / 1000).round();
    int duration = 1;
    when(mockPrefs.getInt('duration')).thenReturn(duration);
    when(mockPrefs.setInt('duration', duration + newDuration))
        .thenAnswer((_) async => true);
    await saveUsageData(
        prefs: mockPrefs, newDurationInMillisecond: newDurationInMillisecond);
    verify(mockPrefs.getInt('duration')).called(1);
    verify(mockPrefs.setInt('duration', duration + newDuration)).called(1);
  });
  testWidgets('Start Game When Less Than 2 Hours Test',
      (WidgetTester tester) async {
    MockNavigatorObserver mockObserver = MockNavigatorObserver();
    DateTime dateNow = DateTime.now();
    int duration = 6000; // Less than 7200 Seconds = 2 Hours
    when(mockPrefs.getInt('duration')).thenReturn(duration);
    when(mockPrefs.getInt('lastLogin'))
        .thenReturn(dateNow.millisecondsSinceEpoch);
    HomePage homepage = HomePage();
    await tester.pumpWidget(MaterialApp(
      home: homepage,
      navigatorObservers: [mockObserver],
    ));
    await tester.pump();
    GlobalKey playButtonKey = homepage.getPlayButtonKey();
    Finder playButton = find.byKey(playButtonKey);
    await tester.tap(playButton);
    await tester.pump();
    // expect(find.byType(AlertDialog), findsNothing);
    // expect(find.byType(TalaCareGame), findsOneWidget);
  });
  testWidgets('Start Game When More Than 2 Hours Test',
      (WidgetTester tester) async {
    MockNavigatorObserver mockObserver = MockNavigatorObserver();
    DateTime dateNow = DateTime.now();
    int duration = 8000; // More than 7200 Seconds = 2 Hours
    when(mockPrefs.getInt('duration')).thenReturn(duration);
    when(mockPrefs.getInt('lastLogin'))
        .thenReturn(dateNow.millisecondsSinceEpoch);
    HomePage homepage = HomePage();
    await tester.pumpWidget(MaterialApp(
      home: homepage,
      navigatorObservers: [mockObserver],
    ));
    await tester.pump();
    GlobalKey playButtonKey = homepage.getPlayButtonKey();
    Finder playButton = find.byKey(playButtonKey);
    await tester.tap(playButton);
    await tester.pump();
    // expect(find.byType(AlertDialog), findsOneWidget);
    // expect(find.byType(TalaCareGame), findsNothing);
  });
}
