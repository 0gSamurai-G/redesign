import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';
import 'package:redesign/shared_preferences/userPreferences.dart';

const _kBg = Color(0xFF000000);
const _kCard = Color(0xFF141414);
const _kGreen = Color(0xFF00FF7F);

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLoading = false;
  bool _isPublicProfile = true;
  String _existingImageUrl = '';
  String _docId = '';

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final name = await UserPreferences.getUserName();
    final phone = await UserPreferences.getUserPhone();
    final email = await UserPreferences.getUserEmail();
    final dob = await UserPreferences.getUserDob();
    final bio = await UserPreferences.getUserBio();
    final imageUrl = await UserPreferences.getProfileImageUrl();
    final docId = await UserPreferences.getDocId();
    final isPublic = await UserPreferences.isPublicProfile();

    if (mounted) {
      setState(() {
        _nameController.text = name ?? '';
        _phoneController.text = phone ?? '';
        _emailController.text = email ?? '';
        _dobController.text = dob ?? '';
        _bioController.text = bio ?? '';
        _existingImageUrl = imageUrl ?? '';
        _docId = docId ?? '';
        _isPublicProfile = isPublic;
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

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name is required")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_docId.isEmpty) {
        throw Exception("Document ID not found. Please re-login.");
      }

      // Upload new image if selected
      String profileImageUrl = _existingImageUrl;
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance.ref().child(
          'Users/Profile/$_docId.jpg',
        );
        await storageRef.putFile(_imageFile!);
        profileImageUrl = await storageRef.getDownloadURL();
      }

      // Update Firestore — edits go to secondary fields only
      final Map<String, dynamic> updatedData = {
        'secondaryEmail': _emailController.text.trim(),
        'secondaryPhone': _phoneController.text.trim(),
        'fullName': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
        'dob': _dobController.text.trim(),
        'profileImageUrl': profileImageUrl,
        'isPublicProfile': _isPublicProfile,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('User')
          .doc(_docId)
          .update(updatedData);

      // Update locally
      await UserPreferences.saveUserProfile(
        _nameController.text.trim(),
        _phoneController.text.trim(),
        _emailController.text.trim(),
        _dobController.text.trim(),
        _bioController.text.trim(),
        profileImageUrl,
      );
      await UserPreferences.setPublicProfile(_isPublicProfile);

      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _kGreen,
                    ),
                  )
                : Text(
                    'Save',
                    style: GoogleFonts.inter(
                      color: _kGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Profile Photo section
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1,
                        ),
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
                          : _existingImageUrl.isNotEmpty
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: _existingImageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Shimmer.fromColors(
                                      baseColor: Colors.grey.shade800,
                                      highlightColor: Colors.grey.shade700,
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (_, __, ___) => _buildPlaceholderAvatar(),
                                  ),
                                )
                              : _buildPlaceholderAvatar(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Change photo',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 14,
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
              'EMAIL ADDRESS',
              'alex.morgan@example.com',
              Icons.email,
              _emailController,
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
                          primary: _kGreen,
                          onPrimary: Colors.black,
                          surface: Color(0xFF282828),
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

            const SizedBox(height: 32),

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
                  activeTrackColor: _kGreen,
                  inactiveThumbColor: Colors.white54,
                  inactiveTrackColor: Colors.white.withOpacity(0.1),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
      ),
      child: Icon(
        Icons.person,
        color: Colors.white.withOpacity(0.4),
        size: 48,
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    IconData icon,
    TextEditingController controller, {
    int maxLines = 1,
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
            hintStyle: const TextStyle(color: Colors.white24),
            prefixIcon: maxLines == 1
                ? Icon(icon, color: Colors.white38, size: 20)
                : Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Icon(icon, color: Colors.white38, size: 20),
                  ),
            filled: true,
            fillColor: _kCard,
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
                color: _kGreen.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
