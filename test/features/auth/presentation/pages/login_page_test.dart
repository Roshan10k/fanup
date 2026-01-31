import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fanup/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/auth/domain/entities/auth_entity.dart';
import 'package:fanup/features/auth/domain/usecases/login_usecase.dart';
import 'package:fanup/features/auth/domain/usecases/register_usecase.dart';

import 'package:fanup/core/services/storage/user_session_service.dart';
import 'package:fanup/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:fanup/features/auth/data/repositories/auth_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock classes - Use the concrete classes, not interfaces
class MockLoginUsecase extends Mock implements LoginUsecase {}
class MockRegisterUsecase extends Mock implements RegisterUsecase {}
class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockUserSessionService extends Mock implements UserSessionService {}
class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockSharedPreferences mockSharedPreferences;
  late MockUserSessionService mockUserSessionService;
  late MockAuthLocalDatasource mockAuthLocalDatasource;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(
      const LoginUsecaseParams(
        email: 'fallback@email.com',
        password: 'fallback',
      ),
    );
  });

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockRegisterUsecase = MockRegisterUsecase();
    mockSharedPreferences = MockSharedPreferences();
    mockUserSessionService = MockUserSessionService();
    mockAuthLocalDatasource = MockAuthLocalDatasource();
    mockAuthRepository = MockAuthRepository();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        // Override all dependent providers
        sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        userSessionServiceProvider.overrideWithValue(mockUserSessionService),
        authLocalDatasourceProvider.overrideWithValue(mockAuthLocalDatasource),
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
      ],
      child: const MaterialApp(home: LoginPage()),
    );
  }

  // ... rest of your tests remain the same
  group('LoginPage UI Elements', () {
    testWidgets('should display welcome text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Welcome back!'), findsOneWidget);
      expect(find.text('Log in to your FanUp account'), findsOneWidget);
    });

    testWidgets('should display email and password labels', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should display login button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display two text form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should display email icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('should display lock icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should display visibility icon for password', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should have signup navigation option', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsWidgets);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('should display logo image', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('LoginPage Form Validation', () {
    testWidgets('should show error for empty fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    testWidgets('should show error for empty email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    testWidgets('should show error for empty password', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    testWidgets('should allow text entry in email field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should allow text entry in password field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.pump();

      final passwordField = tester.widget<TextFormField>(
        find.byType(TextFormField).last,
      );
      expect(passwordField.controller?.text, 'password123');
    });
  });

  group('LoginPage Form Submission', () {
    testWidgets('should call login when form is valid', (tester) async {
      // Arrange
      final completer = Completer<Either<Failure, AuthEntity>>();

      when(() => mockLoginUsecase(any())).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill form fields
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify login usecase was called
      verify(() => mockLoginUsecase(any())).called(1);
    });

    testWidgets('should call login with correct email and password', (
      tester,
    ) async {
      // Arrange
      final completer = Completer<Either<Failure, AuthEntity>>();

      LoginUsecaseParams? capturedParams;
      when(() => mockLoginUsecase(any())).thenAnswer((invocation) {
        capturedParams = invocation.positionalArguments[0] as LoginUsecaseParams;
        return completer.future;
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill form fields
      await tester.enterText(find.byType(TextFormField).first, 'user@test.com');
      await tester.enterText(find.byType(TextFormField).last, 'mypassword');

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify correct params were passed
      expect(capturedParams?.email, 'user@test.com');
      expect(capturedParams?.password, 'mypassword');
    });

    testWidgets('should not call login when form is invalid', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Don't fill any fields (empty form)
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify login usecase was NOT called
      verifyNever(() => mockLoginUsecase(any()));
    });

    testWidgets('should show loading indicator while logging in', (
      tester,
    ) async {
      // Arrange
      final completer = Completer<Either<Failure, AuthEntity>>();

      when(() => mockLoginUsecase(any())).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Fill form fields
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

  });
}