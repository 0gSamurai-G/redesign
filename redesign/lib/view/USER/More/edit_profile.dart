import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/model/user_profile_model.dart';

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

  final _controller = Get.put(UserProfileController());
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final docId = await UserPreferences.getDocId();
    if (docId != null) {
      await _controller.fetchUserProfile(docId);
      final user = _controller.rxUser.value;
      if (user != null) {
        _nameController.text = user.fullName;
        _phoneController.text = user.secondaryPhone;
        _emailController.text = user.primaryEmail;
        _dobController.text = user.dob;
        _bioController.text = user.bio;
      }
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

    final user = _controller.rxUser.value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User data not found")),
      );
      return;
    }

    final updatedUser = user.copyWith(
      fullName: _nameController.text.trim(),
      secondaryPhone: _phoneController.text.trim(),
      secondaryEmail: _emailController.text.trim(),
      dob: _dobController.text.trim(),
      bio: _bioController.text.trim(),
    );

    final success = await _controller.updateUserProfile(
      updatedUser: updatedUser,
      imageFile: _imageFile,
    );

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pop(context);
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
          Obx(() => TextButton(
            onPressed: _controller.isLoading.value ? null : _saveProfile,
            child: _controller.isLoading.value
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
          ),)
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
                          : Obx(() => _controller.profileImageUrl.isNotEmpty
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: _controller.profileImageUrl,
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
                              : _buildPlaceholderAvatar()),
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
                Obx(() => Switch(
                  value: _controller.rxUser.value?.isPublicProfile ?? true,
                  onChanged: (value) {
                    final user = _controller.rxUser.value;
                    if (user != null) {
                      _controller.setUser(user.copyWith(isPublicProfile: value));
                    }
                  },
                  activeColor: Colors.black,
                  activeTrackColor: _kGreen,
                  inactiveThumbColor: Colors.white54,
                  inactiveTrackColor: Colors.white.withOpacity(0.1),
                ),),
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
