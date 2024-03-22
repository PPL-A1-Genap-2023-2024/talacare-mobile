import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talacare/authentication/screens/signup_page.dart';

void main() {
  group('SignUpPage UI tests', () {
    testWidgets('SignUpPage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignUpPage()));

      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Name '), findsOneWidget);
      expect(find.text('Email '), findsOneWidget);
      expect(find.text('Password '), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(ElevatedButton), findsNWidgets(1));
      expect(find.text("Already have an account? Login"), findsOneWidget);
    });

    testWidgets('Successful sign up', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignUpPage()));

      // Enter valid email and password.
      await tester.enterText(find.byKey(ValueKey('nameField')), 'Test User');
      await tester.enterText(find.byKey(ValueKey('emailField')), 'user@example.com');
      await tester.enterText(find.byKey(ValueKey('passwordField')), 'password123');

      // Tap create account button.
      await tester.tap(find.byKey(ValueKey('signupButton')));
      await tester.pump();

      // Update when sign up logic is complete.
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('Invalid email shows error message', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignUpPage()));

      // Enter an invalid email and a valid password.
      await tester.enterText(find.byKey(ValueKey('nameField')), 'Test User');
      await tester.enterText(find.byKey(ValueKey('emailField')), 'invalidEmail');
      await tester.enterText(find.byKey(ValueKey('passwordField')), 'validPassword123');

      // Tap login button.
      await tester.tap(find.byKey(ValueKey('signupButton')));
      await tester.pump();

      // Check for the email validation error message.
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('Empty name shows error message', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignUpPage()));

      // Enter valid email and password but leave name empty.
      await tester.enterText(find.byKey(ValueKey('emailField')), 'user@example.com');
      await tester.enterText(find.byKey(ValueKey('passwordField')), 'password123');

      // Tap Create Account button.
      await tester.tap(find.byKey(ValueKey('signupButton')));
      await tester.pump();

      // Check for the name validation error message.
      expect(find.text('Please enter your name'), findsOneWidget);
    });

    testWidgets('Empty email shows error message', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignUpPage()));

      // Enter valid name and password but leave name empty.
      await tester.enterText(find.byKey(ValueKey('nameField')), 'Test User');
      await tester.enterText(find.byKey(ValueKey('passwordField')), 'password123');

      // Tap Create Account button.
      await tester.tap(find.byKey(ValueKey('signupButton')));
      await tester.pump();

      // Check for the email validation error message.
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('Empty password shows error message', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignUpPage()));

      // Enter valid name and email but leave name empty.
      await tester.enterText(find.byKey(ValueKey('nameField')), 'Test User');
      await tester.enterText(find.byKey(ValueKey('emailField')), 'user@example.com');

      // Tap Create Account button.
      await tester.tap(find.byKey(ValueKey('signupButton')));
      await tester.pump();

      // Check for the password validation error message.
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Test name input does not exceed 255 characters', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignUpPage()));

      final Finder nameField = find.byKey(ValueKey('nameField'));
     
      // Attempt to enter very long name.
      await tester.enterText(nameField, 'a'*300);
     
      String currentValue = (tester.widget(nameField) as TextFormField).controller!.text;

      // Assert that the value does not exceed the specified limit.
      expect(currentValue.length, equals(255));
    });

    testWidgets('Test email input does not exceed 254 characters', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SignUpPage()));

      final Finder emailField = find.byKey(ValueKey('emailField'));
     
      // Attempt to enter very long email.
      await tester.enterText(emailField, 'a'*254+'@example.com');
     
      String currentValue = (tester.widget(emailField) as TextFormField).controller!.text;

      // Assert that the value does not exceed the specified limit.
      expect(currentValue.length, equals(254));
    });

  });
}

