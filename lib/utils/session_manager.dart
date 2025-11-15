import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String keyUserId = "USER_ID";
  static const String keyAuthToken = "AUTH_TOKEN";
  static const String keyIsLoggedIn = "IS_LOGGED_IN";

  // Save user session
  static Future<void> saveSession({
    required String userId,
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserId, userId);
    await prefs.setString(keyAuthToken, token);
    await prefs.setBool(keyIsLoggedIn, true);
  }

  // Check login status
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }

  // Get saved user id
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserId);
  }

  // Get saved token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyAuthToken);
  }

  // Clear session (logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUserId);
    await prefs.remove(keyAuthToken);
    await prefs.remove(keyIsLoggedIn);
  }
}
