import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:talacare/widgets/homepage.dart';
import 'package:mocktail/mocktail.dart';


class MockAudioPlayer extends Mock implements AudioPlayer {}

void main() {
  testWidgets('HomePage Play Button', (WidgetTester tester) async {
    HomePage target = HomePage();
    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: target,
    ));

    final GlobalKey playButtonKey = target.getPlayButtonKey();

    await tester.pump();

    // Verify that HomePage has PlayButton.
    final playIcon = find.byKey(playButtonKey);

    // Tap the PlayButton and trigger a navigation.
    await tester.tap(playIcon);
    await tester.pumpAndSettle();
  });

  testWidgets('Background Music is Playing', (WidgetTester tester) async {
    // Create a mock AudioPlayer
    final mockAudioPlayer = MockAudioPlayer();

    // Build your widget
    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(audioPlayer: mockAudioPlayer),
      ),
    );

    verify(mockAudioPlayer.setLoopMode(LoopMode.one)).called(1);
    verify(mockAudioPlayer.setAudioSource(any)).called(1);
    verify(mockAudioPlayer.play()).called(1);
  });
}
