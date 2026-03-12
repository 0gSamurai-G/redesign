import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../shared_preferences/userPreferences.dart';
import '../../model/User_Models/registerModel.dart';

class RegisterController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Use explicit configuration
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  bool isLoading = false;
  String? errorMessage;

  Future<void> _initGoogleSignIn() async {
    if (!_isGoogleSignInInitialized) {
      await _googleSignIn.initialize(
        clientId:
            '712055791856-mmkgav17dori5j8q3q4d20f7qigefu5l.apps.googleusercontent.com',
        serverClientId:
            '712055791856-mmkgav17dori5j8q3q4d20f7qigefu5l.apps.googleusercontent.com',
      );
      _isGoogleSignInInitialized = true;
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// EMAIL REGISTER
  Future<bool> registerWithEmail(RegisterModel user) async {
    try {
      setLoading(true);
      errorMessage = null;

      final credential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      await credential.user?.updateDisplayName(user.name);

      await UserPreferences.saveUserLogin(true, user.name, user.email);

      setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        '🔴 [RegisterController] FirebaseAuthException: ${e.code} - ${e.message}',
      );
      errorMessage = e.message ?? "An error occurred during registration";
      setLoading(false);
      return false;
    } catch (e, stackTrace) {
      debugPrint('🔴 [RegisterController] registerWithEmail error: $e');
      debugPrint('🔴 StackTrace: $stackTrace');
      errorMessage = e.toString();
      setLoading(false);
      return false;
    }
  }

  /// EMAIL LOGIN
  Future<bool> loginWithEmail(String email, String password) async {
    try {
      setLoading(true);
      errorMessage = null;

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        await UserPreferences.saveUserLogin(
          true,
          user.displayName ?? "User",
          user.email ?? email,
        );
      }

      setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        '🔴 [RegisterController] FirebaseAuthException: ${e.code} - ${e.message}',
      );
      errorMessage = e.message ?? "An error occurred during login";
      setLoading(false);
      return false;
    } catch (e, stackTrace) {
      debugPrint('🔴 [RegisterController] loginWithEmail error: $e');
      debugPrint('🔴 StackTrace: $stackTrace');
      errorMessage = e.toString();
      setLoading(false);
      return false;
    }
  }

  /// GOOGLE LOGIN (v7.2 API)
  Future<bool> loginWithGoogle() async {
    try {
      setLoading(true);
      errorMessage = null;

      await _initGoogleSignIn();

      /// Start Google authentication
      final GoogleSignInAccount account = await _googleSignIn.authenticate();

      /// Get ID token (synchronous getter in v7.2)
      final GoogleSignInAuthentication googleAuth = account.authentication;

      /// Firebase credential (ID TOKEN ONLY)
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;

      if (user != null) {
        await UserPreferences.saveUserLogin(
          true,
          user.displayName ?? "User",
          user.email ?? "",
        );

        setLoading(false);
        return true;
      }

      setLoading(false);
      return false;
    } catch (e, stackTrace) {
      debugPrint('🔴 [RegisterController] loginWithGoogle error: $e');
      debugPrint('🔴 StackTrace: $stackTrace');
      errorMessage = e.toString();
      setLoading(false);
      return false;
    }
  }

  /// SIGN OUT
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.disconnect();
    await UserPreferences.clearUser();
  }
}
