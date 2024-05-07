import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/button.dart';

void main() {
  group('Custom Button Tests', () {
    testWidgets('CustomButton size test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CustomButton(
                  key: Key("smallButton"),
                  text: 'Small',
                  onPressed: () {},
                  size: ButtonSize.small,
                ),
                CustomButton(
                  key: Key("mediumButton"),
                  text: 'Medium',
                  onPressed: () {},
                  size: ButtonSize.medium,
                ),
                CustomButton(
                  key: Key("largeButton"),
                  text: 'Large',
                  onPressed: () {},
                  size: ButtonSize.large,
                ),
              ],
            ),
          ),
        ),
      );

      final smallButtonFinder = find.byKey(Key("smallButton"));
      final mediumButtonFinder = find.byKey(Key("mediumButton"));
      final largeButtonFinder = find.byKey(Key("largeButton"));

      final smallButtonWidth = tester.getSize(smallButtonFinder).width;
      final mediumButtonWidth = tester.getSize(mediumButtonFinder).width;
      final largeButtonWidth = tester.getSize(largeButtonFinder).width;

      expect(smallButtonWidth, equals(150));
      expect(mediumButtonWidth, equals(200));
      expect(largeButtonWidth, equals(270));
    });

    testWidgets('CustomButton text and icon test', (WidgetTester tester) async {
      const buttonText = 'Button';
      const assetImagePath = 'assets/images/Illustrations/google.png';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: buttonText,
              assetImagePath: assetImagePath,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text(buttonText), findsOneWidget);

      expect(find.byKey(const Key('icon_container')), findsOneWidget);
    });

    testWidgets('CustomButton tap test', (WidgetTester tester) async {
      bool isPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              key: Key("Button"),
              text: 'Button',
              onPressed: () {
                isPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(Key("Button")));

      expect(isPressed, isTrue);
    });
  });
}
