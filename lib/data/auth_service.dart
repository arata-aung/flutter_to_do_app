import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  final _authBox = Hive.box('mybox');

  // Register a new user
  Future<bool> register(String username, String password) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return false;
    }

    // Check if user already exists
    final users = _authBox.get('USERS', defaultValue: <String, String>{});
    final Map<String, String> usersMap = Map<String, String>.from(users);
    
    if (usersMap.containsKey(username)) {
      return false; // User already exists
    }

    // Store user credentials
    usersMap[username] = password;
    await _authBox.put('USERS', usersMap);
    return true;
  }

  // Login user
  bool login(String username, String password) {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      return false;
    }

    final users = _authBox.get('USERS', defaultValue: <String, String>{});
    final Map<String, String> usersMap = Map<String, String>.from(users);
    
    return usersMap.containsKey(username) && usersMap[username] == password;
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _authBox.get('CURRENT_USER') != null;
  }

  // Get current user
  String? getCurrentUser() {
    return _authBox.get('CURRENT_USER');
  }

  // Set current user (after successful login)
  Future<void> setCurrentUser(String username) async {
    await _authBox.put('CURRENT_USER', username);
  }

  // Logout
  Future<void> logout() async {
    await _authBox.delete('CURRENT_USER');
  }
}
