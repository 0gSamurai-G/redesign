import 'package:flutter/material.dart';
import 'package:redesign/user_navigation.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

const kSpotifyGreen = Color(0xFF1DB954);
const kBg = Color(0xFF121212);
const kSurface = Color(0xFF181818);
const kCard = Color(0xFF282828);
const kMuted = Color(0xFFA7A7A7);

class FavoriteSportsScreen extends StatefulWidget {
  const FavoriteSportsScreen({super.key});

  @override
  State<FavoriteSportsScreen> createState() => _FavoriteSportsScreenState();
}

class _FavoriteSportsScreenState extends State<FavoriteSportsScreen> {
  final List<String> _sports = [
    'Football',
    'Basketball',
    'Tennis',
    'Cricket',
    'Badminton',
    'Boxing',
    'Swimming',
    'Cycling',
    'Baseball',
    'Table Tennis',
    'Volleyball',
    'Rugby',
  ];

  final List<List<Color>> _gradients = [
    [Color(0xFF8B9B7E), Color(0xFF4A5C43)], // Football
    [Color(0xFFBA7647), Color(0xFF6B3A1C)], // Basketball
    [Color(0xFFB57053), Color(0xFF653018)], // Tennis
    [Color(0xFFD69A6E), Color(0xFF345864)], // Cricket
    [Color(0xFFCE8853), Color(0xFF69351C)], // Badminton
    [Color(0xFFDAC090), Color(0xFF4A4B56)], // Boxing
    [Color(0xFFDB9A54), Color(0xFF5A3018)], // Swimming
    [Color(0xFF90A39C), Color(0xFF354641)], // Cycling
    [Color(0xFF9CB8B5), Color(0xFF425654)], // Baseball
    [Color(0xFFD38B6B), Color(0xFF4B201A)], // Table Tennis
    [Color(0xFF9DB8A9), Color(0xFF324647)], // Volleyball
    [Color(0xFFC9A254), Color(0xFF324B4C)], // Rugby
  ];

  final Set<String> _selectedSports = {};

  void _toggleSport(String sport) {
    setState(() {
      if (_selectedSports.contains(sport)) {
        _selectedSports.remove(sport);
      } else {
        _selectedSports.add(sport);
      }
    });
  }

  void _goNext() {
    if (_selectedSports.length < 4) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProfileSetupScreen(selectedSports: _selectedSports.toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canProceed = _selectedSports.length >= 4;

    return Scaffold(
      backgroundColor: Colors.black, // Pure black background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'STEP 1 OF 2', // Match the design Step 1 of 4
              style: TextStyle(
                color: kMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 3, width: 30, color: kSpotifyGreen),
                const SizedBox(width: 4),
                Container(height: 3, width: 30, color: Colors.white24),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select your favorites',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose at least 4 sports to personalize your feed',
                  style: GoogleFonts.inter(fontSize: 15, color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75, // Taller cards closely matching design
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _sports.length,
              itemBuilder: (context, index) {
                final sport = _sports[index];
                final isSelected = _selectedSports.contains(sport);
                final gradient = _gradients[index % _gradients.length];

                return GestureDetector(
                  onTap: () => _toggleSport(sport),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? kSpotifyGreen : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Blurred Gradient Background
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ),
                        // Dark overlay at bottom for text readability
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(14),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Soft overlay on the whole card
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                        // Selection Icon
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: kSpotifyGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.black,
                                size: 14,
                                weight: 700,
                              ),
                            ),
                          ),
                        // Label text (pill shape behind text)
                        Positioned(
                          bottom: 12,
                          left: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              sport,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom area
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black, Colors.black.withOpacity(0.0)],
              ),
            ),
            child: Column(
              children: [
                Text(
                  '${_selectedSports.length} of 4 sports selected',
                  style: TextStyle(
                    color: canProceed ? Colors.white : kMuted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: canProceed ? _goNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canProceed
                          ? Color(0xFF384358)
                          : kCard, // The specific blueish grey from design when active
                      disabledBackgroundColor: const Color(0xFF20242F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: canProceed ? Colors.white : Colors.white38,
                      ),
                    ),
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

class ProfileSetupScreen extends StatefulWidget {
  final List<String> selectedSports;
  const ProfileSetupScreen({super.key, required this.selectedSports});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLoading = false;
  bool _isPublicProfile = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final name = await UserPreferences.getUserName();
    final email = await UserPreferences.getUserEmail();
    final phone = await UserPreferences.getUserPhone();

    if (mounted) {
      setState(() {
        _nameController.text = name ?? '';
        _emailController.text = email ?? '';
        _phoneController.text = phone ?? '';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _completeSetup() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Name is required")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Determine Document ID (email or phone)
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      final String docId = email.isNotEmpty ? email : phone;

      if (docId.isEmpty) {
        throw Exception("An email or phone number is required.");
      }

      // 2. Upload Image if selected
      String profileImageUrl = '';
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance.ref().child(
          'Users/Profile/$docId.jpg',
        );
        await storageRef.putFile(_imageFile!);
        profileImageUrl = await storageRef.getDownloadURL();
      }

      // 3. Create/Update Firestore Document
      final Map<String, dynamic> userData = {
        'primaryEmail': email,
        'secondaryEmail': email,
        'primaryPhone': phone,
        'secondaryPhone': phone,
        'fullName': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
        'dob': _dobController.text.trim(),
        'profileImageUrl': profileImageUrl,
        'isTrainer': false,
        'favoriteSports': widget.selectedSports,
        'isPublicProfile': _isPublicProfile,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('User')
          .doc(docId)
          .set(userData, SetOptions(merge: true));

      // 4. Save Locally
      await UserPreferences.saveDocId(docId);
      await UserPreferences.setPublicProfile(_isPublicProfile);
      await UserPreferences.saveFavoriteSports(widget.selectedSports);

      await UserPreferences.saveUserProfile(
        _nameController.text.trim(),
        _phoneController.text.trim(),
        _emailController.text.trim(),
        _dobController.text.trim(),
        _bioController.text.trim(),
        profileImageUrl,
      );

      await UserPreferences.setProfileComplete(true);

      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const UserAppNavShell()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error completing setup: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            const Text(
              'STEP 2 OF 2',
              style: TextStyle(
                color: kMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 3, width: 30, color: kSpotifyGreen),
                const SizedBox(width: 4),
                Container(height: 3, width: 30, color: kSpotifyGreen),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Complete your profile',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tell us a bit about yourself to get started.',
              style: GoogleFonts.inter(fontSize: 15, color: Colors.white70),
            ),
            const SizedBox(height: 32),

            // Profile Photo section
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: _imageFile == null
                            ? Border.all(
                                color: Colors.white.withOpacity(0.15),
                                width: 1,
                                style: BorderStyle.none,
                              )
                            : null,
                      ),
                      child: _imageFile != null
                          ? ClipOval(
                              child: Image.file(
                                _imageFile!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : CustomPaint(
                              painter: DashedCirclePainter(
                                color: Colors.white24,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'ADD PHOTO',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white.withOpacity(0.5),
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(
                              0xFF00FF7F,
                            ), // A brighter green like design
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _imageFile != null ? Icons.edit : Icons.add,
                            color: Colors.black,
                            size: 16,
                            weight: 800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            _buildInputField(
              'FULL NAME',
              'Alex Morgan',
              Icons.person,
              _nameController,
            ),
            const SizedBox(height: 20),

            _buildInputField(
              'PHONE NUMBER',
              '+1 (555) 000-1234',
              Icons.phone,
              _phoneController,
            ),
            const SizedBox(height: 20),

            _buildInputField(
              'EMAIL ADDRESS',
              'alex.morgan@example.com',
              Icons.email,
              _emailController,
            ),
            const SizedBox(height: 20),

            _buildInputField(
              'DATE OF BIRTH',
              'mm/dd/yyyy',
              Icons.calendar_today,
              _dobController,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: Color(0xFF00FF7F),
                          onPrimary: Colors.black,
                          surface: kCard,
                          onSurface: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (date != null) {
                  final month = date.month.toString().padLeft(2, '0');
                  final day = date.day.toString().padLeft(2, '0');
                  final year = date.year.toString();
                  _dobController.text = '$month/$day/$year';
                }
              },
            ),
            const SizedBox(height: 20),

            _buildInputField(
              'BIO',
              'Tell us about your favorite sports,\nteams, or what you\'re looking for...',
              Icons.description,
              _bioController,
              maxLines: 3,
            ),

            const SizedBox(height: 20),
            
            // Public Profile Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Public Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Allow anyone to see your stats',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _isPublicProfile,
                  onChanged: (value) {
                    setState(() {
                      _isPublicProfile = value;
                    });
                  },
                  activeColor: Colors.black,
                  activeTrackColor: const Color(0xFF00FF7F),
                  inactiveThumbColor: Colors.white54,
                  inactiveTrackColor: Colors.white.withOpacity(0.1),
                ),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _completeSetup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF7F), // bright neon green
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                        'Complete Setup',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'By continuing, you agree to our Terms of Service',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    IconData icon,
    TextEditingController controller, {
    int maxLines = 1,
    IconData? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white24),
            prefixIcon: maxLines == 1
                ? Icon(icon, color: Colors.white38, size: 20)
                : Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Icon(icon, color: Colors.white38, size: 20),
                  ),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: Colors.white38, size: 20)
                : null,
            filled: true,
            fillColor: const Color(0xFF141414), // Very dark grey
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: const Color(0xFF00FF7F).withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for dashed circle
class DashedCirclePainter extends CustomPainter {
  final Color color;
  DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final double dashWidth = 8;
    final double dashSpace = 6;
    double currentAngle = 0;

    // approx circumference
    final double circumference = 2 * 3.14159 * radius;
    final int dashCount = (circumference / (dashWidth + dashSpace)).floor();
    final double sweepAngle = 2 * 3.14159 / dashCount;

    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        currentAngle,
        sweepAngle * (dashWidth / (dashWidth + dashSpace)),
        false,
        paint,
      );
      currentAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
