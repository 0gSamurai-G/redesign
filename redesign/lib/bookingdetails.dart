import 'package:flutter/material.dart';

const kBgColor = Colors.black;
const kCardColor = Color(0xFF1A1A1A);
const kGreen = Color(0xFF1DB954);
const kMuted = Color(0xFFA7A7A7);


class ConfirmSlotScreen extends StatefulWidget {
  const ConfirmSlotScreen({super.key});

  @override
  State<ConfirmSlotScreen> createState() => _ConfirmSlotScreenState();
}

class _ConfirmSlotScreenState extends State<ConfirmSlotScreen> {
  int selectedDate = 0;
  int players = 4;
  bool soloQueue = true;
  bool payToJoin = true;
  double radius = 5;String selectedType = 'Turf';
String selectedSize = '5-a-side';

final List<String> typeOptions = [
  'Turf',
  'Grass',
  'Indoor',
  'Synthetic',
];

final List<String> sizeOptions = [
  '3-a-side',
  '5-a-side',
  '7-a-side',
  '11-a-side',
];

late final ScrollController _timelineController;
TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
TimeOfDay _endTime = const TimeOfDay(hour: 9, minute: 0);

@override
void initState() {
  super.initState();
  _timelineController = ScrollController();
}

@override
void dispose() {
  _timelineController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Confirm Slot'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text('Step 2/3', style: TextStyle(color: kMuted)),
          )
        ],
      ),

      /// SCROLLABLE BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dateSelector(),
            const SizedBox(height: 24),

            _sectionTitle('Sport & Ground'),
            const SizedBox(height: 8),
            _sportSelector(),
            const SizedBox(height: 20),
            _dropdownRow(),
            const SizedBox(height: 24),

            _availabilityTimeline(),
            const SizedBox(height: 24),

            _timePickers(),
            const SizedBox(height: 32),

            _sectionTitle('Add-ons & Equipment'),
            _addonCard('Pro Match Ball', '+ ₹200', true),
            _addonCard('Extra Bibs (Set of 10)', '+ ₹150', false),
            _addonCard('Referee Service', '+ ₹300', false),
            const SizedBox(height: 32),

            _soloQueueSection(),
            const SizedBox(height: 32),

            _finalSection(),
          ],
        ),
      ),

      /// STICKY CTA
      bottomNavigationBar: _bottomBar(),
    );
  }

  // ------------------------------------------------------------
  // DATE SELECTOR
Widget _dateSelector() {
  final DateTime today = DateTime.now();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _sectionTitle('Select Date'),
      const SizedBox(height: 12),

      /// Height is constrained, not fixed (prevents overflow)
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 90),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 7,
          itemBuilder: (_, index) {
            final date = today.add(Duration(days: index));
            final bool selected = index == selectedDate;

            final String day = _weekdayShort(date.weekday);
            final String month = _monthShort(date.month);
            final String dateNum = date.day.toString();

            return GestureDetector(
              onTap: () => setState(() => selectedDate = index),
              child: Container(
                width: 72,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? kGreen : Colors.black,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? kGreen : Colors.grey.shade800,
                    width: 1.2,
                  ),
                ),

                /// IMPORTANT: mainAxisSize.min avoids overflow
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// DAY
                    Text(
                      index == 0 ? 'TODAY' : day.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      textHeightBehavior:
                          const TextHeightBehavior(applyHeightToFirstAscent: false),
                      style: TextStyle(
                        color: selected ? Colors.black : kMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        letterSpacing: 0.6,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// DATE NUMBER
                    Text(
                      dateNum,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: selected ? Colors.black : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),

                    const SizedBox(height: 2),

                    /// MONTH
                    Text(
                      month.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: selected ? Colors.black : kMuted,
                        fontSize: 11,
                        height: 1.0,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

String _weekdayShort(int weekday) {
  const days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  return days[weekday - 1];
}

String _monthShort(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}


  // ------------------------------------------------------------
  // SPORT SELECTOR
  Widget _sportSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _pill('Football', true),
          _pill('Cricket', false),
          _pill('Tennis', false),
        ],
      ),
    );
  }

  Widget _pill(String label, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: active ? kGreen : Colors.grey.shade700),
      ),
      child: Text(label,
          style: TextStyle(color: active ? kGreen : Colors.white)),
    );
  }

  // ------------------------------------------------------------
  // DROPDOWNS
Widget _dropdownRow() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;

        return Row(
          children: [
            Expanded(
              child: _dropdownCard(
                label: 'Type',
                value: selectedType,
                onTap: () => _openBottomSheet(
                  title: 'Select Type',
                  options: typeOptions,
                  selected: selectedType,
                  onSelected: (value) {
                    setState(() => selectedType = value);
                  },
                ),
              ),
            ),
            SizedBox(width: isWide ? 16 : 12),
            Expanded(
              child: _dropdownCard(
                label: 'Size',
                value: selectedSize,
                onTap: () => _openBottomSheet(
                  title: 'Select Size',
                  options: sizeOptions,
                  selected: selectedSize,
                  onSelected: (value) {
                    setState(() => selectedSize = value);
                  },
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
void _openBottomSheet({
  required String title,
  required List<String> options,
  required String selected,
  required ValueChanged<String> onSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.black,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              /// OPTIONS
              ...options.map((option) {
                final isSelected = option == selected;

                return ListTile(
                  onTap: () {
                    onSelected(option);
                    Navigator.pop(context);
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? kGreen : Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: kGreen)
                      : null,
                );
              }).toList(),
            ],
          ),
        ),
      );
    },
  );
}


Widget _dropdownCard({
  required String label,
  required String value,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade800,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: kMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: kMuted,
            size: 22,
          ),
        ],
      ),
    ),
  );
}


  // ------------------------------------------------------------
  // AVAILABILITY
Widget _availabilityTimeline() {
  final List<_TimeSlot> slots = [
    _TimeSlot(start: '4 AM', end: '5 AM', isFree: false),
    _TimeSlot(start: '5 AM', end: '6 AM', isFree: false),
    _TimeSlot(start: '6 AM', end: '7 AM', isFree: true),
    _TimeSlot(start: '7 AM', end: '8 AM', isFree: true),
    _TimeSlot(start: '8 AM', end: '9 AM', isFree: false),
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Text(
          'Availability',
          style: TextStyle(
            color: kMuted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(height: 12),

      /// ✅ SINGLE SCROLL VIEW (THIS IS THE KEY)
      SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TIME LABELS (UNIQUE: 4 5 6 7 8 9)
            Row(
              children: [
                _TimeLabel(slots.first.start),
                ...slots.map((slot) => _TimeLabel(slot.end)).toList(),
              ],
            ),

            const SizedBox(height: 6),

            /// TIMELINE BLOCKS
            Row(
              children: List.generate(slots.length, (index) {
                final slot = slots[index];
                final isFirst = index == 0;
                final isLast = index == slots.length - 1;

                return Row(
                  children: [
                    _TimelineBlock(
                      slot: slot,
                      isFirst: isFirst,
                      isLast: isLast,
                    ),

                    /// Separator (except last)
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 44,
                        color: Colors.black,
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),

      const SizedBox(height: 12),

      /// LEGEND
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: const [
            _LegendDot(color: Color.fromARGB(255, 255, 44, 44)),
            SizedBox(width: 6),
            Text('Booked', style: TextStyle(color: kMuted)),
            SizedBox(width: 16),
            _LegendDot(color: Color.fromARGB(255, 0, 255, 132)),
            SizedBox(width: 6),
            Text('Free', style: TextStyle(color: kMuted)),
          ],
        ),
      ),
    ],
  );
}





  // ------------------------------------------------------------
  // TIME PICKERS
  Widget _timePickers() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        /// START TIME
        Expanded(
          child: _timeCard(
            label: 'Start Time',
            time: _startTime,
            onTap: () => _pickTime(isStart: true),
          ),
        ),

        const SizedBox(width: 12),

        /// END TIME
        Expanded(
          child: _timeCard(
            label: 'End Time',
            time: _endTime,
            onTap: () => _pickTime(isStart: false),
          ),
        ),
      ],
    ),
  );
}

Widget _timeCard({
  required String label,
  required TimeOfDay time,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGreen, width: 1.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LABEL
          Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              color: kMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 8),

          /// TIME + ICON ROW (PROPERLY ALIGNED)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _formatTime(time),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.access_time,
                color: kGreen,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
String _formatTime(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:00 $period';
}

  // ------------------------------------------------------------
  // ADDONS
  Widget _addonCard(String title, String price, bool selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? kGreen : Colors.grey.shade800),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(color: Colors.white)),
            ),
            Text(price, style: const TextStyle(color: kGreen)),
            const SizedBox(width: 8),
            Icon(selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? kGreen : kMuted),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SOLO QUEUE
  Widget _soloQueueSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: kGreen),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              value: soloQueue,
              activeColor: kGreen,
              title: const Text('Solo Queue Mode',
                  style: TextStyle(color: Colors.white)),
              subtitle: const Text(
                'Allow others to join and split cost',
                style: TextStyle(color: kMuted),
              ),
              onChanged: (v) => setState(() => soloQueue = v),
            ),
            const SizedBox(height: 16),
      
            _sectionTitle('Total Players Needed'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => setState(() => players--),
                    icon: const Icon(Icons.remove, color: Colors.white)),
                Text('$players Players',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () => setState(() => players++),
                    icon: const Icon(Icons.add, color: Colors.white)),
              ],
            ),
      
            const SizedBox(height: 16),
            _sectionTitle('Matchmaking Radius'),
            Slider(
              value: radius,
              min: 1,
              max: 10,
              divisions: 9,
              label: '${radius.toInt()} km',
              activeColor: kGreen,
              onChanged: (v) => setState(() => radius = v),
            ),
      
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: kGreen, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Posting for 4 Players • ₹250/person • Intermediate',
                style: TextStyle(color: kGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // FINAL PAYMENT
  Widget _finalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Additional Notes'),
          _textArea('Write any special requests...'),
          const SizedBox(height: 16),
      
          _policyBox(),
          const SizedBox(height: 24),
      
          _priceRow('Slot Price (1 hr)', '₹1000'),
          _priceRow('Add-ons', '₹200'),
          const Divider(color: Colors.grey),
          _priceRow('Total Amount', '₹1200', highlight: true),
        ],
      ),
    );
  }

  Widget _policyBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Venue Policy',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('• Non-refundable within 4 hours',
              style: TextStyle(color: kMuted)),
          Text('• Steel studs prohibited',
              style: TextStyle(color: kMuted)),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // CTA BAR
  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kGreen,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {},
        child: const Text('Pay & Confirm',
            style: TextStyle(fontSize: 18, color: Colors.black)),
      ),
    );
  }

  // ------------------------------------------------------------
  // HELPERS
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _textArea(String hint) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        maxLines: 3,
        style: const TextStyle(color: Colors.white),
        decoration:
            InputDecoration.collapsed(hintText: hint),
      ),
    );
  }

  Widget _priceRow(String label, String value,
      {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: kMuted)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  color: highlight ? kGreen : Colors.white,
                  fontWeight:
                      highlight ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
  
  Future<void> _pickTime({required bool isStart}) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: isStart ? _startTime : _endTime,
    helpText: 'Select Hour',
    builder: (context, child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: kGreen,
            surface: Colors.black,
            onSurface: Colors.white,
          ),
          timePickerTheme: const TimePickerThemeData(
            backgroundColor: Colors.black,
            hourMinuteTextColor: Colors.white,
            dialHandColor: kGreen,
            dialBackgroundColor: Color(0xFF1A1A1A),
            entryModeIconColor: kGreen,
            helpTextStyle: TextStyle(color: kMuted),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked == null) return;

  /// 🔒 FORCE HOUR-ONLY (minutes = 00)
  final selected = TimeOfDay(hour: picked.hour, minute: 0);

  setState(() {
    if (isStart) {
      _startTime = selected;

      /// 🧠 AUTO-FIX: End time must always be AFTER start time
      if (_endTime.hour <= _startTime.hour) {
        _endTime = TimeOfDay(
          hour: (_startTime.hour + 1).clamp(0, 23),
          minute: 0,
        );
      }
    } else {
      /// 🚫 BLOCK INVALID END TIME
      if (selected.hour <= _startTime.hour) {
        return; // silently ignore invalid selection
      }
      _endTime = selected;
    }
  });
}

  




}
// class _TimeSlot {
//   final String time;
//   final bool isFree;

//   _TimeSlot(this.time, this.isFree);
// }

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
class _TimeLabel extends StatelessWidget {
  final String time;
  const _TimeLabel(this.time);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      alignment: Alignment.centerLeft,
      child: Text(
        time,
        style: const TextStyle(
          color: kMuted,
          fontSize: 12,
        ),
      ),
    );
  }
}
class _TimelineBlock extends StatelessWidget {
  final _TimeSlot slot;
  final bool isFirst;
  final bool isLast;

  const _TimelineBlock({
    required this.slot,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: slot.isFree
            ? Color.fromARGB(255, 0, 180, 93)
            : Color.fromARGB(255, 214, 1, 1),
        borderRadius: BorderRadius.horizontal(
          left: isFirst ? const Radius.circular(12) : Radius.zero,
          right: isLast ? const Radius.circular(12) : Radius.zero,
        ),
      ),
      child: Text(
        slot.isFree ? 'FREE' : 'BOOKED',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
class _TimeSlot {
  final String start;
  final String end;
  final bool isFree;

  _TimeSlot({
    required this.start,
    required this.end,
    required this.isFree,
  });
}
