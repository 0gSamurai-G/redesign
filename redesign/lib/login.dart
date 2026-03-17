import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/user_navigation.dart';
import 'package:redesign/register.dart';
import 'package:redesign/favorite_sports.dart';
import 'package:redesign/controller/User_Controller/registerController.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter/services.dart';
import 'dart:async';

const kSpotifyGreen = Color(0xFF1DB954);
const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);

/* ============================================================
   APP ROOT
   ============================================================ */

/* ============================================================
   LOGIN SCREEN (STATEFUL FOR FUTURE UPGRADES)
   ============================================================ */
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// ---- THEME COLORS (Spotify style)
  static const Color spotifyGreen = Color(0xFF1DB954);
  static const Color charcoal = Color(0xFF121212);
  static const Color cardColor = Color(0xFF181818);
  static const Color inputColor = Color(0xFF222222);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final RegisterController _controller = RegisterController();

  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showPhoneLoginSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const PhoneLoginSheet();
      },
    );
  }

  Future<void> _forgotPassword() async {
    TextEditingController resetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kSurface,
          title: const Text(
            "Reset Password",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: resetController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter your email",
              hintStyle: const TextStyle(color: kMuted),
              filled: true,
              fillColor: kCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kSpotifyGreen,
              ),
              child: const Text(
                "Send Reset Link",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: resetController.text.trim(),
                  );

                  if (!context.mounted) return;
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password reset email sent"),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    bool success = await _controller.loginWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      final docId = _emailController.text.trim();
      final exists = await _checkAndFetchUserDoc(docId);
      if (!mounted) return;
      if (exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserAppNavShell()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FavoriteSportsScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_controller.errorMessage ?? "Login failed")),
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    bool success = await _controller.loginWithGoogle();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      final user = FirebaseAuth.instance.currentUser;
      final docId = user?.email ?? '';
      if (docId.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FavoriteSportsScreen()),
        );
        return;
      }
      final exists = await _checkAndFetchUserDoc(docId);
      if (!mounted) return;
      if (exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserAppNavShell()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FavoriteSportsScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_controller.errorMessage ?? "Google Sign-In failed"),
        ),
      );
    }
  }

  /// Checks if the user doc exists in Firestore. If yes, populates
  /// SharedPreferences with all profile data, marks profile complete, and returns true.
  Future<bool> _checkAndFetchUserDoc(String docId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        await UserPreferences.saveDocId(docId);
        await UserPreferences.saveUserProfile(
          data['fullName'] ?? '',
          data['primaryPhone'] ?? '',
          data['primaryEmail'] ?? '',
          data['dob'] ?? '',
          data['bio'] ?? '',
          data['profileImageUrl'] ?? '',
        );
        final sports = data['favoriteSports'];
        if (sports != null && sports is List) {
          await UserPreferences.saveFavoriteSports(
            sports.map((e) => e.toString()).toList(),
          );
        }
        await UserPreferences.setPublicProfile(data['isPublicProfile'] ?? true);
        await UserPreferences.setTrainer(data['isTrainer'] ?? false);
        await UserPreferences.setProfileComplete(true);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error fetching user doc: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      resizeToAvoidBottomInset: true, // ✅ IMPORTANT
      body: Stack(
        children: [
          /// TOP GRADIENT BACKGROUND
          Container(
            height: size.height * 0.45,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(48),
                bottomRight: Radius.circular(48),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: const [
                  Color(0xFF1DB954), // Spotify green
                  Color(0xFF15883E), // darker green (natural step-down)
                  Color(0xFF0B3D20), // deep green-black blend
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),

          /// ABSTRACT BACKGROUND SHAPE
          Positioned(
            top: -10,
            left: 30,
            right: -50,
            child: Opacity(
              opacity: 0.8,
              child: Transform.rotate(
                angle: -0.5,
                child: Text(
                  'Z',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.luckiestGuy(
                    fontSize: size.width * 1.1,
                    color: Colors.white,
                    height: 1,
                    letterSpacing: -8,
                  ),
                ),
              ),
            ),
          ),

          /// LOGIN CARD + REGISTER TEXT
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                const SizedBox(height: 300), // ✅ unchanged
                /// LOGIN CARD
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: kSurface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// 🎧 TITLE
                          const Text(
                            'Welcome back',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Ready to get back on the field?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: kMuted,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 26),

                          /// 📧 EMAIL
                          _InputField(
                            controller: _emailController,
                            icon: Icons.email_outlined,
                            hint: 'user@playz.com',
                            fillColor: kCard,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Email is required'
                                : null,
                          ),

                          const SizedBox(height: 14),

                          /// 🔒 PASSWORD
                          _InputField(
                            controller: _passwordController,
                            icon: Icons.lock_outline,
                            hint: '••••••••',
                            obscure: true,
                            fillColor: kCard,
                            validator: (value) =>
                                value == null || value.length < 6
                                ? 'Minimum 6 characters'
                                : null,
                          ),

                          const SizedBox(height: 14),

                          /// ☑ REMEMBER + FORGOT
                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.9,
                                child: Checkbox(
                                  value: _rememberMe,
                                  activeColor: kSpotifyGreen,
                                  checkColor: Colors.black,
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.25),
                                  ),
                                  onChanged: (v) =>
                                      setState(() => _rememberMe = v ?? false),
                                ),
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.white70,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: _forgotPassword,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                ),
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: kSpotifyGreen,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          /// 🟢 PRIMARY CTA
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kSpotifyGreen,
                                disabledBackgroundColor: kSpotifyGreen
                                    .withOpacity(0.5),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: _isLoading
                                    ? const SizedBox(
                                        key: ValueKey('loader'),
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.2,
                                          color: Colors.black,
                                        ),
                                      )
                                    : const Row(
                                        key: ValueKey('text'),
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Sign In',
                                            style: TextStyle(
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Colors.black,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          /// ─── DIVIDER
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'or continue with',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.12),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          /// 🌐 SOCIAL BUTTONS
                          Row(
                            children: [
                              Expanded(
                                child: _SocialButton(
                                  icon: Icons.g_mobiledata,
                                  label: 'Google',
                                  onPressed: _handleGoogleLogin,
                                  isLoading: _isLoading,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _SocialButton(
                                  icon: Icons.phone,
                                  label: 'Phone',
                                  onPressed: () {
                                    _showPhoneLoginSheet();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// REGISTER
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => RegisterScreen()),
                          );
                        },
                        child: const Text(
                          'Register here',
                          style: TextStyle(
                            color: spotifyGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ============================================================
   INPUT FIELD
   ============================================================ */
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool obscure;
  final Color fillColor;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.icon,
    required this.hint,
    required this.fillColor,
    this.obscure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/* ============================================================
   SOCIAL BUTTON
   ============================================================ */
class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _SocialButton({
    required this.icon,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed ?? () {},
      icon: Icon(icon, color: const Color(0xFF1DB954)),
      label: Text(label, style: const TextStyle(color: Color(0xFF1DB954))),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.white.withOpacity(0.15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class PhoneLoginSheet extends StatefulWidget {
  const PhoneLoginSheet({super.key});

  @override
  State<PhoneLoginSheet> createState() => _PhoneLoginSheetState();
}

class _PhoneLoginSheetState extends State<PhoneLoginSheet> with CodeAutoFill {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController phoneController = TextEditingController(text: '+91');
  String verificationId = "";

  bool otpSent = false;
  List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  int secondsLeft = 120;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    listenForCode();
    SmsAutoFill().getAppSignature.then((signature) {
      print("APP SIGNATURE: $signature");
    });
    
    for (int i = 0; i < 6; i++) {
      otpFocusNodes[i].onKeyEvent = (node, event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
          if (otpControllers[i].text.isEmpty && i > 0) {
            otpFocusNodes[i - 1].requestFocus();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      };
    }
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    phoneController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 6) {
      for (int i = 0; i < 6; i++) {
        otpControllers[i].text = code![i];
      }
      setState(() {});
      Future.delayed(const Duration(milliseconds: 200), () {
        verifyOTP();
      });
    }
  }

  void _startTimer() {
    secondsLeft = 120;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft == 0) {
        timer.cancel();
      } else {
        if (mounted) setState(() => secondsLeft--);
      }
    });
  }

  Future<void> sendOTP(String phone) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);

        await UserPreferences.saveUserLogin(
          true,
          "User",
          phoneController.text.trim(),
        );

        if (mounted) {
          final docId = phoneController.text.trim();
          final exists = await _checkAndFetchPhoneUserDoc(docId);
          Navigator.pop(context); // Close sheet
          if (exists) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const UserAppNavShell()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FavoriteSportsScreen()),
            );
          }
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? "Verification failed")),
          );
        }
      },
      codeSent: (String verId, int? resendToken) async {
        if (mounted) {
          setState(() {
            verificationId = verId;
            otpSent = true;
          });
          _startTimer();
          listenForCode();
        }
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  Future<void> verifyOTP() async {
    String otp = otpControllers.map((c) => c.text).join();
    if (otp.length < 6) return;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);

      await UserPreferences.saveUserLogin(
        true,
        "User",
        phoneController.text.trim(),
      );

      if (!mounted) return;
      final docId = phoneController.text.trim();
      final exists = await _checkAndFetchPhoneUserDoc(docId);
      Navigator.pop(context); // Close sheet

      if (exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserAppNavShell()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FavoriteSportsScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid OTP")),
        );
      }
    }
  }

  /// Checks if phone-based user doc exists in Firestore.
  Future<bool> _checkAndFetchPhoneUserDoc(String docId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        await UserPreferences.saveDocId(docId);
        await UserPreferences.saveUserProfile(
          data['fullName'] ?? '',
          data['primaryPhone'] ?? '',
          data['primaryEmail'] ?? '',
          data['dob'] ?? '',
          data['bio'] ?? '',
          data['profileImageUrl'] ?? '',
        );
        final sports = data['favoriteSports'];
        if (sports != null && sports is List) {
          await UserPreferences.saveFavoriteSports(
            sports.map((e) => e.toString()).toList(),
          );
        }
        await UserPreferences.setPublicProfile(data['isPublicProfile'] ?? true);
        await UserPreferences.setTrainer(data['isTrainer'] ?? false);
        await UserPreferences.setProfileComplete(true);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error fetching user doc: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// DRAG HANDLE
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            otpSent ? _buildOTPUI() : _buildPhoneUI(),
          ],
        ),
      ),
    );
  }

  /// PHONE INPUT UI
  Widget _buildPhoneUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Enter your phone number",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          "We'll send you a verification code",
          style: TextStyle(color: kMuted),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: phoneController,
                autofocus: true,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Phone number",
                  filled: true,
                  fillColor: kCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              String phone = phoneController.text.trim();
              if (!phone.startsWith('+')) {
                phone = "+$phone"; // ensure + prefix is there for Firebase
              }
              sendOTP(phone);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1DB954),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Send OTP",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// OTP UI
  Widget _buildOTPUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Enter the 6-digit code",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 45,
              child: TextField(
                controller: otpControllers[index],
                focusNode: otpFocusNodes[index],
                autofocus: index == 0,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (value) {
                  // PASTE HANDLING & FAST TYPING
                  if (value.length > 1) {
                    int pasteLength = value.length;
                    for (int i = 0; i < pasteLength && (index + i) < 6; i++) {
                      otpControllers[index + i].text = value[i];
                    }
                    if (index + pasteLength < 6) {
                      otpFocusNodes[index + pasteLength].requestFocus();
                    } else {
                      FocusScope.of(context).unfocus();
                    }
                    setState(() {});

                    // AUTO SUBMIT
                    if (otpControllers.every((c) => c.text.isNotEmpty)) {
                      Future.delayed(const Duration(milliseconds: 200), () {
                        verifyOTP();
                      });
                    }
                    return;
                  }

                  // FORWARD FOCUS
                  if (value.isNotEmpty && index < 5) {
                    otpFocusNodes[index + 1].requestFocus();
                  }

                  // BACKSPACE FOCUS
                  if (value.isEmpty && index > 0) {
                    otpFocusNodes[index - 1].requestFocus();
                  }

                  // AUTO SUBMIT
                  if (otpControllers.every((c) => c.text.isNotEmpty)) {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      verifyOTP();
                    });
                  }
                },
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: kCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        Text(
          "Resend code in ${secondsLeft ~/ 60}:${(secondsLeft % 60).toString().padLeft(2, '0')}",
          style: const TextStyle(color: kMuted, fontSize: 13),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: secondsLeft == 0
              ? () {
                  // Optimistically reset timer and clear old OTP
                  setState(() {
                    secondsLeft = 120;
                  });
                  for (var c in otpControllers) {
                    c.clear();
                  }

                  String phone = phoneController.text.trim();
                  if (!phone.startsWith('+')) phone = "+$phone";
                  sendOTP(phone);
                }
              : null,
          child: Text(
            "RESEND CODE",
            style: TextStyle(
              color: secondsLeft == 0 ? kSpotifyGreen : kMuted,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: verifyOTP,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1DB954),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Verify & Continue",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
