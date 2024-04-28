import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/button.dart';

void main() {
  testWidgets('CustomButton renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Test Button',
            onPressed: () {},
            initialButtonWidth: 500,
          ),
        ),
      ),
    );

    expect(find.text('Test Button'), findsOneWidget);

    await tester.tap(find.byType(InkWell));

    expect(tester.getSize(find.byType(CustomButton)).width, 500);
  });

  testWidgets('CustomButton with icon renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Test Button',
            onPressed: () {},
            assetImagePath: 'assets/images/Illustrations/google.png',
          ),
        ),
      ),
    );

    expect(find.byKey(Key('icon_container')), findsOneWidget);  
  });

  testWidgets('CustomButton with negative button width', (WidgetTester tester) async {
     await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Test Button',
            onPressed: () {},
            initialButtonWidth: -100, // Negative buttonWidth
          ),
        ),
      ),
    );
    // Verify that the button has a minimum width
    expect(tester.getSize(find.byType(CustomButton)).width, CustomButton.defaultButtonWidth);
  });
}
