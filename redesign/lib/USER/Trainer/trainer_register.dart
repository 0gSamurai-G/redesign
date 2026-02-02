import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:redesign/USER/Trainer/trainer_platform_package.dart';


const Color kBg = Color(0xFF000000);
const Color kSurface = Color(0xFF0E0E0E);
const Color kCard = Color(0xFF1A1A1A);
const Color kGreen = Color(0xFF1DB954);
const Color kMuted = Color(0xFFA7A7A7);

class TrainerJoinScreen extends StatefulWidget {
  const TrainerJoinScreen({super.key});

  @override
  State<TrainerJoinScreen> createState() => _TrainerJoinScreenState();
}

class _TrainerJoinScreenState extends State<TrainerJoinScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;


bool isRentedGround = true;

final List<String> facilityPhotos = [];

final TextEditingController addressController = TextEditingController();
final TextEditingController areaController = TextEditingController();
final TextEditingController cityController = TextEditingController();



  final Map<String, List<String>> packagePerks = {
  'Trial': [],
  '1 Month': [],
  '3 Months': [],
  '6 Months': [],
  '1 Year': [],
};

final Set<String> suggestedPerks = {
  'Kit Provided',
  'Video Analysis',
  'Fitness Tracking',
  'Match Practice',
  'Diet Plan',
  'Performance Report',
};

String selectedPackage = 'Trial';

final TextEditingController perkController = TextEditingController();


  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            /// CONTENT
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _JoinAppBar(),
                    const SizedBox(height: 20),
                    const _CertifiedBanner(),
                    const SizedBox(height: 28),
                    const _StepHeader(step: 1, title: 'Personal Information'),
                    const SizedBox(height: 20),
                    const _ProfilePhoto(),
                    const SizedBox(height: 24),



                    _InputField(
                      label: 'Full Name *',
                      initial: 'Rahul Sharma',
                    ),
                    const SizedBox(height: 16),
                    _VerifiedInputField(
                      label: 'Mobile Number *',
                      value: '9876543210',
                    ),
                    const SizedBox(height: 16),
                    _InputField(
                      label: 'Email Address *',
                      initial: 'rahul.sharma@example.com',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: _InputField(
                            label: 'Date of Birth',
                            hint: 'DD/MM/YYYY',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
  child: _DropdownField(
  label: 'Gender',
  value: _gender,
  items: const ['Male', 'Female', 'Other'],
  onChanged: (v) => setState(() => _gender = v),
)
),

                      ],
                    ),


                    const SizedBox(height: 32),
const _StepHeader(step: 2, title: 'Professional Details'),
const SizedBox(height: 20),

/// PRIMARY SPORT
_DropdownField(
  label: 'Primary Sport',
  value: 'Cricket',
  items: const ['Cricket', 'Football', 'Fitness', 'Yoga'], onChanged: (String? value) {  },
),

const SizedBox(height: 16),

/// SPECIALIZATION
_InputField(
  label: 'Specialization',
  hint: 'e.g. Batting Coach, Pace Bowling',
),

const SizedBox(height: 16),

/// CURRENT ACADEMY (OPTIONAL)
_InputField(
  label: 'Current Academy / Club (Optional)',
  hint: 'e.g. PowerPlay Academy',
),

const SizedBox(height: 16),

/// EXPERIENCE
_InputField(
  label: 'Years of Experience',
  hint: 'e.g. 5',
  keyboardType: TextInputType.number,
),

const SizedBox(height: 16),

/// SHORT BIO
_BioField(),

const SizedBox(height: 20),
_CertificationsSection(), // ✅ Section 3


const SizedBox(height: 32),
    _CoachingPreferencesSection(),
const SizedBox(height: 32),
    _AvailabilitySection(),
const SizedBox(height: 32),
   _PricingPackagesSection(), 
const SizedBox(height: 32),
LocationInfraSection(), 
const SizedBox(height: 32),
IdentityVerificationSection(),
const SizedBox(height: 32),
PayoutDetailsSection(),
const SizedBox(height: 32),
AgreementsSection(),












    const SizedBox(height: 120),

 /// CTA
 const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _isValid ? () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>TrainerProAccessScreen()));
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: const Text(
                'Continue',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),

                  ],
                ),
              ),
            ),

           
          ],
        ),
      ),
    );
  }
}


class _JoinAppBar extends StatelessWidget {
  const _JoinAppBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Join as a Trainer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Complete your profile to start earning',
              style: TextStyle(color: kMuted, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}


class _CertifiedBanner extends StatelessWidget {
  const _CertifiedBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            kGreen.withOpacity(0.25),
            kSurface,
          ],
        ),
        border: Border.all(color: kGreen.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kGreen.withOpacity(0.25),
            ),
            child: const Icon(Icons.verified, color: kGreen),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Certified Trainer Program',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 6),
                Text(
                  'Join 500+ coaches. Manage sessions, track earnings, and grow your athlete base.',
                  style: TextStyle(color: kMuted, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _StepHeader extends StatelessWidget {
  final int step;
  final String title;
  const _StepHeader({required this.step, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: kGreen,
          child: Text(
            step.toString(),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}


class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 46,
            backgroundColor: kCard,
            child: Icon(Icons.person, size: 42, color: kMuted),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: kGreen,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.camera_alt,
                  size: 16, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}


class _InputField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? initial;
  final TextEditingController? controller; // ✅ NEW
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const _InputField({
    required this.label,
    this.hint,
    this.initial,
    this.controller, // ✅ NEW
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initial : null, // ✅ SAFE
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14.5,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: kGreen,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: kMuted),
        hintStyle: TextStyle(color: kMuted.withOpacity(0.6)),
        filled: true,
        fillColor: kCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kGreen, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}



class _VerifiedInputField extends StatelessWidget {
  final String label;
  final String value;

  const _VerifiedInputField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kMuted),
        suffixIcon: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: kGreen, size: 18),
            SizedBox(width: 6),
            Text('Verified', style: TextStyle(color: kGreen)),
            SizedBox(width: 12),
          ],
        ),
        filled: true,
        fillColor: kCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}


// class _DropdownField extends StatelessWidget {
//   final String label;
//   final String value;

//   const _DropdownField({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       value: value,
//       dropdownColor: kCard,
//       items: const [
//         DropdownMenuItem(value: 'Male', child: Text('Male')),
//         DropdownMenuItem(value: 'Female', child: Text('Female')),
//         DropdownMenuItem(value: 'Other', child: Text('Other')),
//       ],
//       onChanged: (_) {},
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: kCard,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       style: const TextStyle(color: Colors.white),
//     );
//   }
// }


class _DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue = items.contains(value) ? value : null;

    return DropdownButtonFormField<String>(
      value: safeValue,
      onChanged: onChanged,
      isExpanded: true,
      icon: const Icon(Icons.expand_more_rounded, color: kMuted),
      dropdownColor: kSurface,
      menuMaxHeight: 280,
      borderRadius: BorderRadius.circular(18),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: kCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: kGreen, width: 1.2),
        ),
      ),
      items: items.map((e) {
        final isSelected = e == safeValue;
        return DropdownMenuItem(
          value: e,
          child: Text(
            e,
            style: TextStyle(
              color: isSelected ? kGreen : Colors.white,
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        );
      }).toList(),
    );
  }
}





class _BioField extends StatefulWidget {
  @override
  State<_BioField> createState() => _BioFieldState();
}

class _BioFieldState extends State<_BioField> {
  final controller = TextEditingController();
  static const maxLength = 200;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          controller: controller,
          maxLines: 4,
          maxLength: maxLength,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Short Bio',
            hintText: 'Briefly describe your coaching style...',
            hintStyle: const TextStyle(color: kMuted),
            labelStyle: const TextStyle(color: kMuted),
            filled: true,
            fillColor: kCard,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kGreen),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 4),
        Text(
          '${controller.text.length}/$maxLength',
          style: const TextStyle(color: kMuted, fontSize: 11),
        ),
      ],
    );
  }
}


class _CertificationsSection extends StatelessWidget {
  const _CertificationsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// STEP HEADER
        Row(
          children: const [
            _StepIndicator(number: 3),
            SizedBox(width: 10),
            Text(
              'Certifications',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        /// TRUST INFO CARD
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(14),
            border: const Border(
              left: BorderSide(color: kGreen, width: 3),
            ),
          ),
          child: const Text(
            'Adding valid certifications increases your profile trust score by 40%.',
            style: TextStyle(
              color: kMuted,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),

        const SizedBox(height: 20),

        /// ISSUING AUTHORITY
        const _InputField(
          label: 'Issuing Authority',
          hint: 'e.g. BCCI, ICC, NSNIS',
        ),

        const SizedBox(height: 20),

        /// UPLOAD CERTIFICATE
        _UploadCertificateCard(),

        const SizedBox(height: 14),

        /// UPLOADED FILE PREVIEW
        const _UploadedCertificateTile(
          fileName: 'BCCI Level 1.pdf',
          fileSize: '1.2 MB',
        ),
      ],
    );
  }
}


class _StepIndicator extends StatelessWidget {
  final int number;
  const _StepIndicator({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: kGreen,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}


class _UploadCertificateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // TODO: open file picker
      },
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cloud_upload_outlined, color: kGreen, size: 32),
            SizedBox(height: 10),
            Text(
              'Upload Certificate',
              style: TextStyle(
                color: kGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'PDF or JPG (Max 5MB)',
              style: TextStyle(
                color: kMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _UploadedCertificateTile extends StatelessWidget {
  final String fileName;
  final String fileSize;

  const _UploadedCertificateTile({
    required this.fileName,
    required this.fileSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          /// FILE ICON
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.insert_drive_file_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          /// FILE INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fileSize,
                  style: const TextStyle(
                    color: kMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          /// DELETE
          InkWell(
            onTap: () {
              // TODO: remove file
            },
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}


class _CoachingPreferencesSection extends StatefulWidget {
  const _CoachingPreferencesSection();

  @override
  State<_CoachingPreferencesSection> createState() =>
      _CoachingPreferencesSectionState();
}

class _CoachingPreferencesSectionState
    extends State<_CoachingPreferencesSection> {
  final Set<String> _selectedLevels = {'Kids', 'Adults'};
  bool _willingToTravel = true;
  bool _onlineCoaching = false;
    bool _isComfortable = false;

  final levels = [
    'Kids',
    'Adults',
    'Women Only',
    'Pro Athletes',
    'Beginners',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// STEP HEADER
        Row(
          children: const [
            _StepIndicator(number: 4),
            SizedBox(width: 10),
            Text(
              'Coaching Preferences',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        const Text(
          'Coaching Level (Select all that apply)',
          style: TextStyle(
            color: kMuted,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 12),

        /// LEVEL CHIPS
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: levels.map((level) {
            final selected = _selectedLevels.contains(level);
            return _SelectableChip(
              label: level,
              selected: selected,
              onTap: () {
                setState(() {
                  selected
                      ? _selectedLevels.remove(level)
                      : _selectedLevels.add(level);
                });
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        /// TOGGLES
        _PreferenceToggle(
          label: 'Willing to Travel?',
          value: _willingToTravel,
          onChanged: (v) => setState(() => _willingToTravel = v),
        ),

        const SizedBox(height: 12),

        _PreferenceToggle(
          label: 'Online Coaching Available?',
          value: _onlineCoaching,
          onChanged: (v) => setState(() => _onlineCoaching = v),
        ),

        const SizedBox(height: 12),

        _PreferenceToggle(
          label: 'Comfortable training women/girls?',
          value: _isComfortable,
          onChanged: (v) => setState(() => _isComfortable = v),
        ),
      ],
    );
  }
}


class _SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? kGreen.withOpacity(0.15) : kCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? kGreen : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? kGreen : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}


class _PreferenceToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PreferenceToggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: kGreen,
            activeTrackColor: kGreen.withOpacity(0.4),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}


class _AvailabilitySection extends StatefulWidget {
  const _AvailabilitySection();

  @override
  State<_AvailabilitySection> createState() => _AvailabilitySectionState();
}

class _AvailabilitySectionState extends State<_AvailabilitySection> {
  final Set<String> _selectedDays = {'M', 'T', 'W', 'T', 'F'};
  final Set<String> _selectedSlots = {
    'Morning (6–10 AM)',
    'Evening (5–9 PM)',
  };

  final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final slots = [
    'Morning (6–10 AM)',
    'Afternoon (12–4 PM)',
    'Evening (5–9 PM)',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// STEP HEADER
        Row(
          children: const [
            _StepIndicator(number: 5),
            SizedBox(width: 10),
            Text(
              'Availability',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /// DAYS
        const Text(
          'Days Available',
          style: TextStyle(
            color: kMuted,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(days.length, (i) {
            final day = days[i];
            final selected = _selectedDays.contains('$i-$day');

            return _DayCircle(
              label: day,
              selected: selected,
              onTap: () {
                setState(() {
                  selected
                      ? _selectedDays.remove('$i-$day')
                      : _selectedDays.add('$i-$day');
                });
              },
            );
          }),
        ),

        const SizedBox(height: 20),

        /// TIME SLOTS
        const Text(
          'Preferred Time Slots',
          style: TextStyle(
            color: kMuted,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: slots.map((slot) {
            final selected = _selectedSlots.contains(slot);
            return _TimeSlotChip(
              label: slot,
              selected: selected,
              onTap: () {
                setState(() {
                  selected
                      ? _selectedSlots.remove(slot)
                      : _selectedSlots.add(slot);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}


class _DayCircle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DayCircle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? kGreen : kCard,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}


class _TimeSlotChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TimeSlotChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? kGreen.withOpacity(0.15) : kCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? kGreen : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? kGreen : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}


class _PricingPackagesSection extends StatefulWidget {
  const _PricingPackagesSection();

  @override
  State<_PricingPackagesSection> createState() =>
      _PricingPackagesSectionState();
}

class _PricingPackagesSectionState extends State<_PricingPackagesSection> {
  final Map<String, bool> enabled = {
    'Trial': true,
    'Monthly': true,
    '3 Months': false,
    '6 Months': false,
    '1 Year': false,
  };

  final Map<String, TextEditingController> priceControllers = {
    'Trial': TextEditingController(),
    'Monthly': TextEditingController(),
    '3 Months': TextEditingController(),
    '6 Months': TextEditingController(),
    '1 Year': TextEditingController(),
  };

  final Map<String, List<String>> perks = {
    'Trial': [],
    'Monthly': [],
    '3 Months': [],
    '6 Months': [],
    '1 Year': [],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        Row(
          children: const [
            _StepIndicator(number: 6),
            SizedBox(width: 10),
            Text(
              'Pricing & Packages',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
_PerksSection(),
const SizedBox(height: 16),
        ...enabled.keys.map((key) {
          return _PackagePricingCard(
            title: key,
            enabled: enabled[key]!,
            priceController: priceControllers[key]!,
            perks: perks[key]!,
            onToggle: (v) => setState(() => enabled[key] = v),
            onAddPerk: (perk) =>
                setState(() => perks[key]!.add(perk)),
            onRemovePerk: (perk) =>
                setState(() => perks[key]!.remove(perk)),
          );
        }).toList(),

        const SizedBox(height: 12),

        const Text(
          'Note: Final pricing is subject to platform review.',
          style: TextStyle(
            color: kMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}


class _PackagePricingCard extends StatelessWidget {
  final String title;
  final bool enabled;
  final TextEditingController priceController;
  final List<String> perks;
  final ValueChanged<bool> onToggle;
  final ValueChanged<String> onAddPerk;
  final ValueChanged<String> onRemovePerk;

  const _PackagePricingCard({
    required this.title,
    required this.enabled,
    required this.priceController,
    required this.perks,
    required this.onToggle,
    required this.onAddPerk,
    required this.onRemovePerk,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: enabled ? kGreen : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE + CHECK
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: enabled,
                activeColor: kGreen,
                onChanged: onToggle,
              ),
            ],
          ),

          if (enabled) ...[
            const SizedBox(height: 12),

            /// PRICE INPUT
            _InputField(
              label: 'Price (₹)',
              hint: 'e.g. 2000',
              controller: priceController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 12),

            /// PERKS
            const Text(
              'Included Perks',
              style: TextStyle(
                color: kMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: perks
                  .map(
                    (p) => _PerkChip(
                      text: p,
                      onRemove: () => onRemovePerk(p),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 8),

            _AddPerkField(onAdd: onAddPerk),
          ],
        ],
      ),
    );
  }
}


class _AddPerkField extends StatefulWidget {
  final ValueChanged<String> onAdd;
  const _AddPerkField({required this.onAdd});

  @override
  State<_AddPerkField> createState() => _AddPerkFieldState();
}

class _AddPerkFieldState extends State<_AddPerkField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Add a perk (e.g. Video Analysis)',
              hintStyle: const TextStyle(color: kMuted),
              filled: true,
              fillColor: kSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.add_circle, color: kGreen),
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              widget.onAdd(controller.text.trim());
              controller.clear();
            }
          },
        ),
      ],
    );
  }
}


// class _PerkChip extends StatelessWidget {
//   final String text;
//   final VoidCallback onRemove;

//   const _PerkChip({
//     required this.text,
//     required this.onRemove,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: kSurface,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: kGreen.withOpacity(0.4)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             text,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 12.5,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(width: 6),
//           GestureDetector(
//             onTap: onRemove,
//             child: const Icon(
//               Icons.close,
//               size: 16,
//               color: kMuted,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


Widget _PerksSection() {
  final Map<String, List<String>> packagePerks = {
  'Trial': [],
  '1 Month': [],
  '3 Months': [],
  '6 Months': [],
  '1 Year': [],
};

final Set<String> suggestedPerks = {
  'Kit Provided',
  'Video Analysis',
  'Fitness Tracking',
  'Match Practice',
  'Diet Plan',
  'Performance Report',
};

String selectedPackage = 'Trial';

final TextEditingController perkController = TextEditingController();

  final perks = packagePerks[selectedPackage]!;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 12),

      /// TITLE
      const Text(
        'Package Perks',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),

      const SizedBox(height: 8),

      /// ACTIVE PERKS (CHIPS)
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: perks.map((perk) {
          return _PerkChip(
            text: perk,
            onRemove: () {
              perks.remove(perk);
            },
          );
        }).toList(),
      ),

      const SizedBox(height: 12),

      /// ADD PERK INPUT
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: perkController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Add a perk (e.g. Injury Rehab)',
                hintStyle: TextStyle(color: kMuted.withOpacity(0.6)),
                filled: true,
                fillColor: kCard,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: kGreen),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.add_circle, color: kGreen),
            onPressed: () {
              final text = perkController.text.trim();
              if (text.isEmpty) return;

              if (!perks.contains(text)) {
                perks.add(text);
                suggestedPerks.add(text); // 🔥 learns new perk
              }

              perkController.clear();
            },
          )
        ],
      ),

      const SizedBox(height: 12),

      /// SUGGESTED PERKS
      const Text(
        'Suggested',
        style: TextStyle(
          color: kMuted,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),

      const SizedBox(height: 6),

      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: suggestedPerks.map((perk) {
          final isAdded = perks.contains(perk);
          return _SuggestionChip(
            text: perk,
            active: isAdded,
            onTap: () {
              if (!isAdded) {
                perks.add(perk);
              }
            },
          );
        }).toList(),
      ),
    ],
  );
}


class _PerkChip extends StatelessWidget {
  final String text;
  final VoidCallback onRemove;

  const _PerkChip({
    required this.text,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: kGreen.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kGreen),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: kGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 14,
              color: kGreen,
            ),
          )
        ],
      ),
    );
  }
}


class _SuggestionChip extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? kGreen.withOpacity(0.2) : kCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? kGreen : Colors.grey.shade800,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? kGreen : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}




class LocationInfraSection extends StatefulWidget {
  const LocationInfraSection({super.key});

  @override
  State<LocationInfraSection> createState() => _LocationInfraSectionState();
}
class _LocationInfraSectionState extends State<LocationInfraSection> {
  bool isRentedGround = true;

  final List<String> facilityPhotos = [];

  final TextEditingController addressController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    areaController.dispose();
    cityController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ───────── HEADER ─────────
        Row(
          children: [
            _StepIndicator(number: 6),
            const SizedBox(width: 10),
            const Text(
              'Location & Infra',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /// ───────── TRAINING GROUND ─────────
        const Text(
          'Training Ground',
          style: TextStyle(color: kMuted, fontSize: 13),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            _GroundChip(
              label: 'Own Ground',
              selected: !isRentedGround,
              onTap: () {
                setState(() => isRentedGround = false);
              },
            ),
            const SizedBox(width: 10),
            _GroundChip(
              label: 'Rented / Partner',
              selected: isRentedGround,
              onTap: () {
                setState(() => isRentedGround = true);
              },
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// ───────── LOCATION INPUT ─────────
        const Text(
          'Training Location',
          style: TextStyle(color: kMuted, fontSize: 13),
        ),
        const SizedBox(height: 10),

        _InputField(
          label: 'Full Address',
          hint: 'Street / Ground name',
          controller: addressController,
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _InputField(
                label: 'Area',
                hint: 'e.g. Baner',
                controller: areaController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InputField(
                label: 'City',
                hint: 'e.g. Pune',
                controller: cityController,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// ───────── FACILITY PHOTOS ─────────
        const Text(
          'Facility Photos',
          style: TextStyle(color: kMuted, fontSize: 13),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: facilityPhotos.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _AddPhotoTile(
                  onTap: () {
                    // TODO: Image picker
                  },
                );
              }

              return _PhotoPreviewTile(
                imageUrl: facilityPhotos[index - 1],
              );
            },
          ),
        ),
      ],
    );
  }
}


// class _StepIndicator extends StatelessWidget {
//   final int number;
//   const _StepIndicator({required this.number});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 26,
//       height: 26,
//       alignment: Alignment.center,
//       decoration: const BoxDecoration(
//         color: kGreen,
//         shape: BoxShape.circle,
//       ),
//       child: Text(
//         number.toString(),
//         style: const TextStyle(
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }


class _GroundChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GroundChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? kGreen.withOpacity(0.15) : kCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? kGreen : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? kGreen : kMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}


class _AddPhotoTile extends StatelessWidget {
  final VoidCallback onTap;
  const _AddPhotoTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 96,
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: kMuted,
          size: 28,
        ),
      ),
    );
  }
}


class _PhotoPreviewTile extends StatelessWidget {
  final String imageUrl;
  const _PhotoPreviewTile({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl,
        width: 96,
        height: 96,
        fit: BoxFit.cover,
      ),
    );
  }
}


class IdentityVerificationSection extends StatefulWidget {
  const IdentityVerificationSection({super.key});

  @override
  State<IdentityVerificationSection> createState() =>
      _IdentityVerificationSectionState();
}

class _IdentityVerificationSectionState
    extends State<IdentityVerificationSection> {
  String selectedIdType = 'Aadhaar Card';

  final TextEditingController idNumberController = TextEditingController();

  String? frontImage;
  String? backImage;
  String? selfieImage;

  @override
  void dispose() {
    idNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ───────── HEADER ─────────
        Row(
          children: [
            _StepIndicator(number: 7),
            const SizedBox(width: 10),
            const Text(
              'Identity Verification',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        /// ───────── GOVERNMENT ID TYPE ─────────
        const Text(
          'Government ID Type',
          style: TextStyle(color: kMuted, fontSize: 13),
        ),
        const SizedBox(height: 8),

        _DropdownField(
          label: 'ID Type',
          value: selectedIdType,
          items: const [
            'Aadhaar Card',
            'PAN Card',
            'Passport',
            'Driving License',
          ],
          onChanged: (v) {
            if (v != null) {
              setState(() => selectedIdType = v);
            }
          },
        ),

        const SizedBox(height: 14),

        /// ───────── ID NUMBER ─────────
        _InputField(
          label: 'ID Number',
          hint: 'XXXX-XXXX-XXXX',
          keyboardType: TextInputType.text,
          controller: idNumberController,
        ),

        const SizedBox(height: 18),

        /// ───────── FRONT / BACK UPLOAD ─────────
        Row(
          children: [
            Expanded(
              child: _UploadCard(
                label: 'Front Side',
                icon: Icons.badge_outlined,
                image: frontImage,
                onTap: () {
                  // TODO: pick front image
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _UploadCard(
                label: 'Back Side',
                icon: Icons.badge_outlined,
                image: backImage,
                onTap: () {
                  // TODO: pick back image
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        /// ───────── SELFIE WITH ID ─────────
        const Text(
          'Selfie with ID',
          style: TextStyle(color: kMuted, fontSize: 13),
        ),
        const SizedBox(height: 10),

        _SelfieCard(
          image: selfieImage,
          onTap: () {
            // TODO: open camera
          },
        ),

        const SizedBox(height: 10),

        /// ───────── SECURITY NOTE ─────────
        Row(
          children: const [
            Icon(Icons.lock_outline, size: 14, color: kMuted),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Your ID is securely stored and only used for verification.',
                style: TextStyle(
                  color: kMuted,
                  fontSize: 11.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _UploadCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? image;
  final VoidCallback onTap;

  const _UploadCard({
    required this.label,
    required this.icon,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kCard,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 96,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: kMuted.withOpacity(0.15),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white70, size: 22),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _SelfieCard extends StatelessWidget {
  final String? image;
  final VoidCallback onTap;

  const _SelfieCard({
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kCard,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kGreen.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: kGreen,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Take a Selfie',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Hold your ID card near your face',
                      style: TextStyle(
                        color: kMuted,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PayoutDetailsSection extends StatefulWidget {
  const PayoutDetailsSection({super.key});

  @override
  State<PayoutDetailsSection> createState() => _PayoutDetailsSectionState();
}

class _PayoutDetailsSectionState extends State<PayoutDetailsSection> {
  final TextEditingController accountNameController =
      TextEditingController();
  final TextEditingController accountNumberController =
      TextEditingController();
  final TextEditingController ifscController = TextEditingController();

  @override
  void dispose() {
    accountNameController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ───────── HEADER ─────────
        Row(
          children: [
            _StepIndicator(number: 8),
            const SizedBox(width: 10),
            const Text(
              'Payout Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        const Text(
          'Used to transfer your earnings securely',
          style: TextStyle(
            color: kMuted,
            fontSize: 12.5,
          ),
        ),

        const SizedBox(height: 16),

        /// ───────── ACCOUNT HOLDER NAME ─────────
        _InputField(
          label: 'Account Holder Name',
          hint: 'As per bank records',
          controller: accountNameController,
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: 12),

        /// ───────── ACCOUNT NUMBER ─────────
        _InputField(
          label: 'Account Number',
          hint: 'Enter account number',
          controller: accountNumberController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),

        const SizedBox(height: 12),

        /// ───────── IFSC CODE ─────────
        _InputField(
          label: 'IFSC Code',
          hint: 'e.g. HDFC0001234',
          controller: ifscController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        ),

        const SizedBox(height: 10),

        /// ───────── SECURITY NOTE ─────────
        Row(
          children: const [
            Icon(
              Icons.lock_outline,
              size: 14,
              color: kMuted,
            ),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Your bank details are encrypted and only used for payouts.',
                style: TextStyle(
                  color: kMuted,
                  fontSize: 11.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class AgreementsSection extends StatefulWidget {
  const AgreementsSection({super.key});

  @override
  State<AgreementsSection> createState() => _AgreementsSectionState();
}

class _AgreementsSectionState extends State<AgreementsSection> {
  bool agreeTerms = true;
  bool agreeMarketing = true;
  bool agreeResponse = false;

  bool get canProceed => agreeTerms && agreeMarketing && agreeResponse;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ───────── HEADER ─────────
        Row(
          children: [
            _StepIndicator(number: 9),
            const SizedBox(width: 10),
            const Text(
              'Agreements',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        /// ───────── AGREEMENT LIST ─────────
        _AgreementTile(
          value: agreeTerms,
          onChanged: (v) => setState(() => agreeTerms = v),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                height: 1.5,
              ),
              children: [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        _AgreementTile(
          value: agreeMarketing,
          onChanged: (v) => setState(() => agreeMarketing = v),
          child: const Text(
            'I consent to the use of my profile photos for marketing purposes.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 10),

        _AgreementTile(
          value: agreeResponse,
          onChanged: (v) => setState(() => agreeResponse = v),
          child: const Text(
            'I agree to respond to user inquiries within 24 hours.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 14),

        /// ───────── NOTE ─────────
        Row(
          children: const [
            Icon(
              Icons.info_outline,
              size: 14,
              color: kMuted,
            ),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'These agreements are mandatory to activate your trainer profile.',
                style: TextStyle(
                  color: kMuted,
                  fontSize: 11.5,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// OPTIONAL: expose validation state
        if (!canProceed)
          const Text(
            'Please accept all agreements to continue.',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}


class _AgreementTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget child;

  const _AgreementTile({
    required this.value,
    required this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(0, -2),
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              activeColor: kGreen,
              checkColor: Colors.black,
              side: const BorderSide(color: kMuted),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(child: child),
        ],
      ),
    );
  }
}


