import 'package:flutter_test/flutter_test.dart';
import 'package:flowcycle/core/services/auth_service.dart';

void main() {
  late AuthService authService;

  setUp(() {
    authService = AuthService.instance;
  });

  group('AuthService Comprehensive Unit Test Suite', () {
    test('1. Validates and signs in user with email & password', () async {
      final failResult = await authService.signInWithEmailAndPassword(
        email: 'invalid-email',
        password: 'pass',
      );
      expect(failResult.isSuccess, isFalse);
      expect(failResult.errorMessage, contains('valid email'));

      final shortPassResult = await authService.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: '123',
      );
      expect(shortPassResult.isSuccess, isFalse);
      expect(shortPassResult.errorMessage, contains('6 characters'));

      final successResult = await authService.signInWithEmailAndPassword(
        email: 'amina@flowcycle.app',
        password: 'securepassword123',
      );
      expect(successResult.isSuccess, isTrue);
      expect(successResult.user?.email, 'amina@flowcycle.app');
      expect(authService.isAuthenticated, isTrue);
    });

    test('2. Registers a new account with email, password, and name', () async {
      final noNameResult = await authService.registerWithEmailAndPassword(
        email: 'maya@flowcycle.app',
        password: 'password123',
        name: '',
      );
      expect(noNameResult.isSuccess, isFalse);
      expect(noNameResult.errorMessage, contains('enter your name'));

      final successResult = await authService.registerWithEmailAndPassword(
        email: 'maya@flowcycle.app',
        password: 'password123',
        name: 'Maya Lin',
      );
      expect(successResult.isSuccess, isTrue);
      expect(successResult.user?.displayName, 'Maya Lin');
      expect(authService.currentUser?.displayName, 'Maya Lin');
    });

    test('3. Authenticates via Google and Apple social providers', () async {
      final googleResult = await authService.signInWithGoogle();
      expect(googleResult.isSuccess, isTrue);
      expect(googleResult.user?.displayName, contains('Google'));

      final appleResult = await authService.signInWithApple();
      expect(appleResult.isSuccess, isTrue);
      expect(appleResult.user?.displayName, contains('Apple'));
    });

    test('4. Sends password reset email and handles sign out', () async {
      final resetResult = await authService.sendPasswordResetEmail(
        'amina@flowcycle.app',
      );
      expect(resetResult.isSuccess, isTrue);

      await authService.signOut();
      expect(authService.isAuthenticated, isFalse);
      expect(authService.currentUser, isNull);
    });
  });
}
