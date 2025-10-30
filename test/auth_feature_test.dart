import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/auth_service.dart';

void main() {
  late Box testBox;
  late AuthService authService;

  setUpAll(() async {
    // Initialize Hive for testing
    await Hive.initFlutter();
  });

  setUp(() async {
    // Open a test box and clear it before each test
    testBox = await Hive.openBox('test_auth_box');
    await testBox.clear();
    
    // Note: AuthService uses 'mybox', so we need to ensure it's available
    if (!Hive.isBoxOpen('mybox')) {
      await Hive.openBox('mybox');
    }
    await Hive.box('mybox').clear();
    
    authService = AuthService();
  });

  tearDown(() async {
    await Hive.box('mybox').clear();
  });

  group('Authentication Tests', () {
    test('register creates a new user', () async {
      final result = await authService.register('testuser', 'password123');
      expect(result, true);
      
      // Verify user was stored
      final users = Hive.box('mybox').get('USERS', defaultValue: <String, String>{});
      final usersMap = Map<String, String>.from(users);
      expect(usersMap.containsKey('testuser'), true);
      expect(usersMap['testuser'], 'password123');
    });

    test('register fails with empty username', () async {
      final result = await authService.register('', 'password123');
      expect(result, false);
    });

    test('register fails with empty password', () async {
      final result = await authService.register('testuser', '');
      expect(result, false);
    });

    test('register fails for duplicate username', () async {
      await authService.register('testuser', 'password123');
      final result = await authService.register('testuser', 'newpassword');
      expect(result, false);
    });

    test('login validates correct credentials', () async {
      await authService.register('testuser', 'password123');
      // Note: login() only validates credentials, setCurrentUser() must be called separately
      final result = authService.login('testuser', 'password123');
      expect(result, true);
    });

    test('login fails with incorrect password', () async {
      await authService.register('testuser', 'password123');
      final result = authService.login('testuser', 'wrongpassword');
      expect(result, false);
    });

    test('login fails with non-existent user', () async {
      final result = authService.login('nonexistent', 'password123');
      expect(result, false);
    });

    test('login fails with empty username', () {
      final result = authService.login('', 'password123');
      expect(result, false);
    });

    test('login fails with empty password', () {
      final result = authService.login('testuser', '');
      expect(result, false);
    });

    test('isLoggedIn returns false when no user is logged in', () {
      expect(authService.isLoggedIn(), false);
    });

    test('isLoggedIn returns true after setCurrentUser', () async {
      await authService.setCurrentUser('testuser');
      expect(authService.isLoggedIn(), true);
    });

    test('getCurrentUser returns null when no user is logged in', () {
      expect(authService.getCurrentUser(), null);
    });

    test('getCurrentUser returns username after setCurrentUser', () async {
      await authService.setCurrentUser('testuser');
      expect(authService.getCurrentUser(), 'testuser');
    });

    test('logout clears current user', () async {
      await authService.setCurrentUser('testuser');
      expect(authService.isLoggedIn(), true);
      
      await authService.logout();
      expect(authService.isLoggedIn(), false);
      expect(authService.getCurrentUser(), null);
    });

    test('multiple users can be registered', () async {
      await authService.register('user1', 'pass1');
      await authService.register('user2', 'pass2');
      await authService.register('user3', 'pass3');
      
      final users = Hive.box('mybox').get('USERS', defaultValue: <String, String>{});
      final usersMap = Map<String, String>.from(users);
      
      expect(usersMap.length, 3);
      expect(usersMap['user1'], 'pass1');
      expect(usersMap['user2'], 'pass2');
      expect(usersMap['user3'], 'pass3');
    });

    test('each user credentials are validated independently', () async {
      await authService.register('user1', 'pass1');
      await authService.register('user2', 'pass2');
      
      // Verify each user can be authenticated with their own password
      expect(authService.login('user1', 'pass1'), true);
      expect(authService.login('user2', 'pass2'), true);
      // Verify cross-authentication fails
      expect(authService.login('user1', 'pass2'), false);
      expect(authService.login('user2', 'pass1'), false);
    });
  });
}
