import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/login.dart';
import 'package:redesign/user_navigation.dart';

void main() {
  runApp(const MyApp());
}

/* ============================================================
   APP ROOT
   ============================================================ */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayZ Register',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const RegisterScreen(),
    );
  }
}

/* ============================================================
   REGISTER SCREEN
   ============================================================ */
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// Spotify theme colors
  static const Color spotifyGreen = Color(0xFF1DB954);
  static const Color charcoal = Color(0xFF121212);
  static const Color cardColor = Color(0xFF181818);
  static const Color inputColor = Color(0xFF222222);

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    // TODO: Navigate to Home / Login
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){return UserAppNavShell();}));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Stack(
        children: [
          /// TOP GRADIENT
          Container(
            height: size.height * 0.45,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(48),
                bottomRight: Radius.circular(48),
              ),
              gradient: const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF1DB954),
    Color(0x801DB954),
    Color(0x001DB954),
  ],
  stops: [0.0, 0.4, 1.0],
)


            ),
          ),

          /// ABSTRACT BACKGROUND SHAPE
          Positioned(
  top: -10,
  left: 30,
  right: -50,
  child: Opacity(
    opacity: 0.6,
    child: Transform.rotate(
      angle: -0.5, // ≈ 30 degrees in radians (30° = 0.5236)
      child: Text(
        'Z',
        textAlign: TextAlign.center,
        style: GoogleFonts.luckiestGuy(
          fontSize: size.width * 1.1, // responsive scaling
          color: Colors.white,    // Spotify green
          height: 1,
          letterSpacing: -8,
        ),
      ),
    ),
  ),
),

          /// REGISTER CARD
          Column(
            children: [
              const SizedBox(height: 280),
              SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Join the PlayZ sports community',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.65),
                          ),
                        ),
                        const SizedBox(height: 24),

                        _InputField(
                          controller: _nameController,
                          icon: Icons.person_outline,
                          hint: 'Full Name',
                          fillColor: inputColor,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),

                        _InputField(
                          controller: _emailController,
                          icon: Icons.email_outlined,
                          hint: 'Email Address',
                          fillColor: inputColor,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),

                        _InputField(
                          controller: _passwordController,
                          icon: Icons.lock_outline,
                          hint: 'Password',
                          obscure: true,
                          fillColor: inputColor,
                          validator: (v) =>
                              v != null && v.length < 6
                                  ? 'Min 6 characters'
                                  : null,
                        ),
                        const SizedBox(height: 16),

                        _InputField(
                          controller: _confirmPasswordController,
                          icon: Icons.lock_outline,
                          hint: 'Confirm Password',
                          obscure: true,
                          fillColor: inputColor,
                          validator: (v) =>
                              v != _passwordController.text
                                  ? 'Passwords do not match'
                                  : null,
                        ),
                        const SizedBox(height: 24),

                        /// CREATE ACCOUNT BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: spotifyGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  )
                                : const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// SIGN IN LINK
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Sign in',
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
        prefixIcon: Icon(icon, color: Colors.white70),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white38),
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