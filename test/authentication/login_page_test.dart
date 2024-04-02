import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/authentication/screens/login_page.dart';

void main() {
  group('LoginPage UI tests', () {
    testWidgets('LoginPage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      expect(find.text('Welcome to Talacare'), findsOneWidget);
      expect(find.text('Log in with Google'), findsOneWidget);
      expect(find.byKey(const ValueKey('loginButton')), findsOneWidget);
    });
  });
}

