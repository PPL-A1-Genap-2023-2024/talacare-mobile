import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/main.dart';
import 'package:talacare/talacare.dart';
import 'package:talacare/widgets/overlays/pause_button.dart';
import 'package:talacare/widgets/overlays/pause_menu.dart';
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
}
