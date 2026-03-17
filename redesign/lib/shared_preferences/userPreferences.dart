import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserName = 'userName';
  static const String _keyUserEmail = 'userEmail';
  static const String _keyIsProfileComplete = 'isProfileComplete';
  static const String _keyFavoriteSports = 'favoriteSports';
  static const String _keyUserPhone = 'userPhone';
  static const String _keyUserDob = 'userDob';
  static const String _keyUserBio = 'userBio';
  static const String _keyProfileImageUrl = 'profileImageUrl';
  static const String _keyDocId = 'docId';
  static const String _keyIsPublicProfile = 'isPublicProfile';

  static Future<void> saveUserLogin(
    bool isLoggedIn,
    String name,
    String email,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyIsProfileComplete);
    await prefs.remove(_keyFavoriteSports);
    await prefs.remove(_keyUserPhone);
    await prefs.remove(_keyUserDob);
    await prefs.remove(_keyUserBio);
    await prefs.remove(_keyProfileImageUrl);
    await prefs.remove(_keyDocId);
    await prefs.remove(_keyIsPublicProfile);
  }

  // Profile setup status
  static Future<void> setProfileComplete(bool isComplete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsProfileComplete, isComplete);
  }

  static Future<bool> isProfileComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsProfileComplete) ?? false;
  }

  // Favorite sports
  static Future<void> saveFavoriteSports(List<String> sports) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyFavoriteSports, sports);
  }

  static Future<List<String>> getFavoriteSports() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavoriteSports) ?? [];
  }

  // Extended Profile
  static Future<void> saveUserProfile(
    String name,
    String phone,
    String email,
    String dob,
    String bio,
    String profileImageUrl,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserPhone, phone);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserDob, dob);
    await prefs.setString(_keyUserBio, bio);
    await prefs.setString(_keyProfileImageUrl, profileImageUrl);
  }

  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserPhone);
  }

  static Future<String?> getProfileImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfileImageUrl);
  }

  static Future<String?> getUserDob() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserDob);
  }

  static Future<String?> getUserBio() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserBio);
  }

  // Document ID
  static Future<void> saveDocId(String docId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDocId, docId);
  }

  static Future<String?> getDocId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDocId);
  }

  // Public Profile
  static Future<void> setPublicProfile(bool isPublic) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsPublicProfile, isPublic);
  }

  static Future<bool> isPublicProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsPublicProfile) ?? true; // Default to true
  }
}
