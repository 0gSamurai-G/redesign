// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// /* ============================================================
//    APP ROOT
//    ============================================================ */
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'PlayZ Login',
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         useMaterial3: true,
//         fontFamily: 'Roboto',
//       ),
//       home: const LoginScreen(),
//     );
//   }
// }

// /* ============================================================
//    LOGIN SCREEN (STATEFUL FOR FUTURE UPGRADES)
//    ============================================================ */
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   /// ---- THEME COLORS (Spotify style)
//   static const Color spotifyGreen = Color(0xFF1DB954);
//   static const Color charcoal = Color(0xFF121212);
//   static const Color cardColor = Color(0xFF181818);
//   static const Color inputColor = Color(0xFF222222);

//   /// ---- FORM & INPUT CONTROLLERS
//   /// These make it easy to:
//   /// - Validate input
//   /// - Send data to APIs
//   /// - Clear fields
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   /// ---- UI STATE (future-proof)
//   bool _rememberMe = false;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     /// Always dispose controllers to avoid memory leaks
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   /// ---- LOGIN HANDLER (placeholder)
//   /// Replace this with Firebase / API logic later
//   Future<void> _handleLogin() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     // Simulate network delay
//     await Future.delayed(const Duration(seconds: 2));

//     setState(() => _isLoading = false);

//     // TODO: Navigate to Home Screen
//     // Navigator.pushReplacement(...)
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: charcoal,
//       body: Stack(
//         children: [
//           /// --------------------------------------------------
//           /// TOP GRADIENT BACKGROUND
//           /// --------------------------------------------------
//           Container(
//             height: size.height * 0.45,
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(48),
//                 bottomRight: Radius.circular(48),
//               ),
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color(0xFF1DB954),
//                   Color(0xFF0F5132),
//                 ],
//               ),
//             ),
//           ),

//           /// --------------------------------------------------
//           /// ABSTRACT BACKGROUND SHAPE (OPTIONAL BRANDING)
//           /// --------------------------------------------------
//           Positioned(
//             top: -40,
//             left: -40,
//             right: -48,
//             child: Opacity(
//               opacity: 0.4,
//               child: Image.asset(
//                 'assets/logo_shapez.png', // placeholder asset
//                 height: size.height * 0.48,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),

//           /// --------------------------------------------------
//           /// LOGIN CARD
//           /// --------------------------------------------------
//           Column(
//             children: [
//               const SizedBox(height: 300),
//               SingleChildScrollView(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//                 child: Container(
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: cardColor,
//                     borderRadius: BorderRadius.circular(28),
//                     border: Border.all(
//                       color: Colors.white.withOpacity(0.08),
//                     ),
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           'Welcome Back!',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           'Ready to get back on the field?',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.white.withOpacity(0.65),
//                           ),
//                         ),
//                         const SizedBox(height: 24),

//                         /// EMAIL
//                         _InputField(
//                           controller: _emailController,
//                           icon: Icons.email_outlined,
//                           hint: 'user@playz.com',
//                           fillColor: inputColor,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Email is required';
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 16),

//                         /// PASSWORD
//                         _InputField(
//                           controller: _passwordController,
//                           icon: Icons.lock_outline,
//                           hint: '••••••••',
//                           obscure: true,
//                           fillColor: inputColor,
//                           validator: (value) {
//                             if (value == null || value.length < 6) {
//                               return 'Minimum 6 characters';
//                             }
//                             return null;
//                           },
//                         ),

//                         const SizedBox(height: 12),

//                         /// REMEMBER ME + FORGOT PASSWORD
//                         Row(
//                           children: [
//                             Checkbox(
//                               value: _rememberMe,
//                               activeColor: spotifyGreen,
//                               onChanged: (value) {
//                                 setState(() => _rememberMe = value ?? false);
//                               },
//                             ),
//                             Text(
//                               'Remember me',
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.white.withOpacity(0.8),
//                               ),
//                             ),
//                             const Spacer(),
//                             TextButton(
//                               onPressed: () {
//                                 // TODO: Forgot password flow
//                               },
//                               child: const Text(
//                                 'Forgot Password?',
//                                 style: TextStyle(
//                                   color: spotifyGreen,
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 16),

//                         /// SIGN IN BUTTON
//                         SizedBox(
//                           width: double.infinity,
//                           height: 54,
//                           child: ElevatedButton(
//                             onPressed: _isLoading ? null : _handleLogin,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: spotifyGreen,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               elevation: 0,
//                             ),
//                             child: _isLoading
//                                 ? const SizedBox(
//                                     height: 22,
//                                     width: 22,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: Colors.black,
//                                     ),
//                                   )
//                                 : const Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         'Sign In',
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       SizedBox(width: 8),
//                                       Icon(Icons.arrow_forward,
//                                           color: Colors.black),
//                                     ],
//                                   ),
//                           ),
//                         ),

//                         const SizedBox(height: 28),

//                         /// DIVIDER
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Divider(
//                                   color: Colors.white.withOpacity(0.15)),
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 12),
//                               child: Text(
//                                 'or continue with',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.white.withOpacity(0.5),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Divider(
//                                   color: Colors.white.withOpacity(0.15)),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 16),

//                         /// SOCIAL LOGIN
//                         Row(
//                           children: const [
//                             Expanded(
//                               child: _SocialButton(
//                                 icon: Icons.g_mobiledata,
//                                 label: 'Google',
//                               ),
//                             ),
//                             SizedBox(width: 12),
//                             Expanded(
//                               child: _SocialButton(
//                                 icon: Icons.apple,
//                                 label: 'Apple',
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// /* ============================================================
//    INPUT FIELD (REUSABLE)
//    ============================================================ */
// class _InputField extends StatelessWidget {
//   final TextEditingController controller;
//   final IconData icon;
//   final String hint;
//   final bool obscure;
//   final Color fillColor;
//   final String? Function(String?)? validator;

//   const _InputField({
//     required this.controller,
//     required this.icon,
//     required this.hint,
//     required this.fillColor,
//     this.obscure = false,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscure,
//       validator: validator,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
//         filled: true,
//         fillColor: fillColor,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }

// /* ============================================================
//    SOCIAL BUTTON (REUSABLE)
//    ============================================================ */
// class _SocialButton extends StatelessWidget {
//   final IconData icon;
//   final String label;

//   const _SocialButton({
//     required this.icon,
//     required this.label,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton.icon(
//       onPressed: () {
//         // TODO: Social auth
//       },
//       icon: Icon(icon, color: const Color(0xFF1DB954)),
//       label: Text(
//         label,
//         style: const TextStyle(color: Color(0xFF1DB954)),
//       ),
//       style: OutlinedButton.styleFrom(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         side: BorderSide(color: Colors.white.withOpacity(0.15)),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }
// }















import 'package:flutter/material.dart';
import 'package:redesign/home.dart';
import 'package:redesign/navigation.dart';
import 'package:redesign/register.dart';

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
      title: 'PlayZ Login',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}

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

  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    // TODO: Navigate to Home Screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AppNavShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: charcoal,
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
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1DB954),
                  Color(0xFF0F5132),
                ],
              ),
            ),
          ),

          /// ABSTRACT BACKGROUND SHAPE
          Positioned(
            top: -40,
            left: -40,
            right: -48,
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/logo_shapez.png',
                height: size.height * 0.48,
                fit: BoxFit.contain,
              ),
            ),
          ),

          /// LOGIN CARD + REGISTER TEXT
          Column(
            children: [
              const SizedBox(height: 300),

              /// LOGIN CARD
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Ready to get back on the field?',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.65),
                          ),
                        ),
                        const SizedBox(height: 24),

                        /// EMAIL
                        _InputField(
                          controller: _emailController,
                          icon: Icons.email_outlined,
                          hint: 'user@playz.com',
                          fillColor: inputColor,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        /// PASSWORD
                        _InputField(
                          controller: _passwordController,
                          icon: Icons.lock_outline,
                          hint: '••••••••',
                          obscure: true,
                          fillColor: inputColor,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Minimum 6 characters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        /// REMEMBER ME + FORGOT PASSWORD
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: spotifyGreen,
                              onChanged: (value) {
                                setState(() => _rememberMe = value ?? false);
                              },
                            ),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: spotifyGreen,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// SIGN IN BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: spotifyGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward,
                                          color: Colors.black),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        /// DIVIDER
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                  color: Colors.white.withOpacity(0.15)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
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
                                  color: Colors.white.withOpacity(0.15)),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// SOCIAL LOGIN
                        Row(
                          children: const [
                            Expanded(
                              child: _SocialButton(
                                icon: Icons.g_mobiledata,
                                label: 'Google',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _SocialButton(
                                icon: Icons.apple,
                                label: 'Apple',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// --------------------------------------------------
              /// REGISTER HERE (BELOW LOGIN CARD)
              /// --------------------------------------------------
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
                        // TODO: Navigate to Register Screen
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                          return RegisterScreen();
                          }));
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

  const _SocialButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: const Color(0xFF1DB954)),
      label: Text(
        label,
        style: const TextStyle(color: Color(0xFF1DB954)),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.white.withOpacity(0.15)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}