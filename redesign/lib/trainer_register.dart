import 'dart:ui';

import 'package:flutter/material.dart';


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


















 /// CTA
 const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _isValid ? () {} : null,
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
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const _InputField({
    required this.label,
    this.hint,
    this.initial,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initial,
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
