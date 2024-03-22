import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/authentication/screens/login_page.dart';

void main() {
  group('LoginPage UI tests', () {
    testWidgets('LoginPage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      expect(find.text('Login to Talacare'), findsOneWidget);
      expect(find.text('Email '), findsOneWidget);
      expect(find.text('Password '), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text("Don't have an account yet? Sign up"), findsOneWidget);
    });

    testWidgets('Successful login', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      // Enter valid email and password.
      await tester.enterText(find.byKey(ValueKey('emailField')), 'user@example.com');
      await tester.enterText(find.byKey(ValueKey('passwordField')), 'password123');

      // Tap login button.
      await tester.tap(find.byKey(ValueKey('loginButton')));
      await tester.pump();

      // Update when login logic is complete.
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('Invalid email shows error message', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      // Enter an invalid email and a valid password.
      await tester.enterText(find.byKey(ValueKey('emailField')), 'invalidEmail');
      await tester.enterText(find.byKey(ValueKey('passwordField')), 'validPassword123');

      // Tap login button.
      await tester.tap(find.byKey(ValueKey('loginButton')));
      await tester.pump();

      // Check for the email validation error message.
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('Empty password shows error message', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      // Enter a valid email and leave the password field empty.
      await tester.enterText(find.byKey(ValueKey('emailField')), 'user@example.com');
      await tester.tap(find.byKey(ValueKey('loginButton')));
      await tester.pump();

      // Check for the password validation error message.
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Test email input does not exceed 254 characters', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      final Finder emailField = find.byKey(ValueKey('emailField'));
     
      // Attempt to enter very long email.
      await tester.enterText(emailField, 'a'*254+'@example.com');
     
      String currentValue = (tester.widget(emailField) as TextFormField).controller!.text;

      // Assert that the value does not exceed the specified limit.
      expect(currentValue.length, equals(254));
    });
  });
}

