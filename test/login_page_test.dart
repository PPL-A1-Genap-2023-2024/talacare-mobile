import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/components/button.dart';
import 'package:talacare/screens/login_page.dart';
import 'package:talacare/screens/homepage.dart';

void main() {
  group('LoginPage UI Test', () {
    testWidgets('LoginPage UI components test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(),
      ));

      expect(find.text('Selamat Datang'), findsOneWidget);

      expect(find.text('di Talacare'), findsOneWidget);

      expect(find.byType(Image), findsNWidgets(1));

      expect(find.byType(CustomButton), findsOneWidget);

      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('Navigate after without account button pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(),
      ));

      await tester.tap(find.text('Masuk tanpa akun'));

      await tester.pumpAndSettle();

      // expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
