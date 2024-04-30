import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/widgets/homepage.dart';

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

  testWidgets('Background Music is playing on HomePage', (WidgetTester tester) async {
    // Arrange
    final subject = HomePage();

    await tester.pumpWidget(MaterialApp(
      home: subject,
    ));

    final subjectState = tester.state<HomePageState>(find.byType(HomePage));
    expect(subjectState.bgm, isNotNull);
    expect(subjectState.bgm.playing, true);
  });
}
