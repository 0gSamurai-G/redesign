import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/USER/Book/payment_success.dart';

const kBgColor = Colors.black;
const kCardColor = Color(0xFF1A1A1A);
const kGreen = Color(0xFF1DB954);
const kMuted = Color(0xFFA7A7A7);
const Color kBottomSheetColor = Color(0xFF121212);

class ConfirmSlotScreen extends StatefulWidget {
  const ConfirmSlotScreen({super.key});

  @override
  State<ConfirmSlotScreen> createState() => _ConfirmSlotScreenState();
}

class _ConfirmSlotScreenState extends State<ConfirmSlotScreen> {
  bool soloQueue = false;
int players = 4;
double radius = 10;
bool bringOwnEquipment = false;
bool splitAndPay = false;
 int baseSlotPrice = 1000;
late final ScrollController _timelineController;

static const int _startHour = 1;   // 6 AM
static const int _totalHours = 23; // 6 AM → 6 PM
static const double _slotWidth = 90;
static const double _separatorWidth = 2;


  DateTime? selectedDate;
  bool payToJoin = true;
  String? selectedType;
  String? selectedSize;
  final Set<String> _selectedAddons = {};

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
bool get _isReadyToPay {
  if (selectedDate == null) return false;
  if (selectedSport == null) return false;
  if (selectedType == null || selectedType!.isEmpty) return false;
  if (selectedSize == null || selectedSize!.isEmpty) return false;
  if (_startTime == null || _endTime == null) return false;
  return _endTime!.hour > _startTime!.hour;
}
int get _totalAmount {
  int basePrice = 1000;

  // Example for later:
  // if (proBallSelected) basePrice += 200;

  return basePrice;
}

TimeOfDay? _startTime;
TimeOfDay? _endTime;
String? selectedSport;

@override
void initState() {
  super.initState();
  _timelineController = ScrollController();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _waitForTimelineAndScroll();
  });
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
      extendBody: true,
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
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 110),
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
            const SizedBox(height: 5),
            _addonCard('Pro Match Ball', '+ ₹200'),
            _addonCard('Extra Bibs (Set of 10)', '+ ₹150'),
            _addonCard('Referee Service', '+ ₹300'),
            const SizedBox(height: 28),

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
            final bool selected = selectedDate != null && _isSameDate(selectedDate!, date);

            final String day = _weekdayShort(date.weekday);
            final String month = _monthShort(date.month);
            final String dateNum = date.day.toString();

            return GestureDetector(
              onTap: () => setState(() => selectedDate = date),
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

bool _isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
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
  final sports = ['Football', 'Cricket', 'Tennis'];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      children: sports.map((sport) {
        final bool isActive = selectedSport == sport;

        return _sportPill(
          label: sport,
          active: isActive,
          onTap: () {
            setState(() => selectedSport = sport);
          },
        );
      }).toList(),
    ),
  );
}
Widget _sportPill({
  required String label,
  required bool active,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(30),
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: active ? kGreen.withOpacity(0.15) : Colors.black,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: active ? kGreen : Colors.grey.shade700,
          width: active ? 1.4 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? kGreen : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
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
  String? selected,
  required ValueChanged<String> onSelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: kBottomSheetColor,
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
  String? value,
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
                  value ?? 'Select',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: value == null ? kMuted : Colors.white,
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
 void _autoScrollToNextHour() {
  final now = DateTime.now();

  int effectiveHour =
      now.minute >= 30 ? now.hour + 1 : now.hour;

  effectiveHour = effectiveHour.clamp(
    _startHour,
    _startHour + _totalHours - 1,
  );

  final int index = effectiveHour - _startHour;

  final double itemExtent = _slotWidth + _separatorWidth;
  double offset = index * itemExtent;

  final viewportWidth =
      _timelineController.position.viewportDimension;

  offset -= (viewportWidth - _slotWidth) / 2;

  offset = offset.clamp(
    _timelineController.position.minScrollExtent,
    _timelineController.position.maxScrollExtent,
  );

  _timelineController.animateTo(
    offset,
    duration: const Duration(milliseconds: 450),
    curve: Curves.easeOutCubic,
  );
}


void _waitForTimelineAndScroll() {
  if (!_timelineController.hasClients) {
    // wait one more frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waitForTimelineAndScroll();
    });
    return;
  }

  _autoScrollToNextHour();
}

  



Widget _availabilityTimeline() {
  final List<_TimeSlot> slots = List.generate(_totalHours, (index) {
    final int start = _startHour + index;
    final int end = start + 1;

    return _TimeSlot(
      start: _formatHour(start),
      end: _formatHour(end),
      isFree: index.isEven, // mock availability (replace with API)
    );
  });

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Availability',
          style: TextStyle(
            color: kMuted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(height: 12),

      /// SINGLE SCROLLABLE TIMELINE
      SingleChildScrollView(
        controller: _timelineController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TIME LABELS (6 AM → 6 PM)
            Row(
              children: [
                _TimeLabel(slots.first.start),
                ...slots.map((s) => _TimeLabel(s.end)).toList(),
              ],
            ),

            const SizedBox(height: 6),

            /// BLOCKS
            Row(
              children: List.generate(slots.length, (index) {
                final slot = slots[index];
                final bool isFirst = index == 0;
                final bool isLast = index == slots.length - 1;

                return Row(
                  children: [
                    _TimelineBlock(
                      slot: slot,
                      isFirst: isFirst,
                      isLast: isLast,
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 44,
                        color: Colors.grey.shade800,
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
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _LegendDot(color: Color(0xFFD60101)),
            SizedBox(width: 6),
            Text('Booked', style: TextStyle(color: kMuted)),
            SizedBox(width: 16),
            _LegendDot(color: Color(0xFF00B45D)),
            SizedBox(width: 6),
            Text('Free', style: TextStyle(color: kMuted)),
          ],
        ),
      ),
    ],
  );
}


String _formatHour(int hour) {
  final int h = hour % 24;
  final int displayHour = h == 0 ? 12 : h > 12 ? h - 12 : h;
  final String period = h >= 12 ? 'PM' : 'AM';
  return '$displayHour $period';
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
  required TimeOfDay? time,
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
                style: TextStyle(
                  color: time == null ? kMuted : Colors.white,
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
String _formatTime(TimeOfDay? time) {
  if (time == null) return '--:--';
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:00 $period';
}

  // ------------------------------------------------------------
  // ADDONS
Widget _addonCard(String title, String price) {
  final selected = _selectedAddons.contains(title);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias, // 🔑 CONTAINS SPLASH
      child: InkWell(
        onTap: () {
          setState(() {
            if (selected) {
              _selectedAddons.remove(title);
            } else {
              _selectedAddons.add(title);
            }
          });
        },
        splashColor: kGreen.withOpacity(0.15),
        highlightColor: kGreen.withOpacity(0.08),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black, // Spotify dark base
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? kGreen : Colors.grey.shade800,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  color: kGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                selected
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: selected ? kGreen : kMuted,
              ),
            ],
          ),
        ),
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
        color: const Color(0xFF121212), // Spotify dark surface
        border: Border.all(color: kGreen),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// SOLO QUEUE TOGGLE
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: soloQueue,
            activeColor: kGreen,
            title: const Text(
              'Solo Queue Mode',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              'Allow others to join and split cost',
              style: TextStyle(color: kMuted),
            ),
            onChanged: (v) => setState(() => soloQueue = v),
          ),

          /// EXTRA OPTIONS (ONLY WHEN ENABLED)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _soloQueueExtras(),
            crossFadeState: soloQueue
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
            sizeCurve: Curves.easeOut,
          ),
        ],
      ),
    ),
  );
}

Widget _soloQueueExtras() {
  final int perPersonAmount =
      splitAndPay ? (baseSlotPrice / players).ceil() : baseSlotPrice;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),

      /// TOTAL PLAYERS
      const Text(
        'Total Players Needed',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: players > 1
                ? () => setState(() => players--)
                : null,
            icon: const Icon(Icons.remove),
            color: Colors.white,
          ),
          Text(
            '$players Players',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () => setState(() => players++),
            icon: const Icon(Icons.add),
            color: Colors.white,
          ),
        ],
      ),

      const SizedBox(height: 20),

      /// SPLIT & PAY TOGGLE
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: splitAndPay,
        activeColor: kGreen,
        title: const Text(
          'Split & Pay',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          splitAndPay
              ? 'Each player pays ₹$perPersonAmount'
              : 'Host pays full amount',
          style: const TextStyle(color: kMuted),
        ),
        onChanged: (v) => setState(() => splitAndPay = v),
      ),

      const SizedBox(height: 16),

      /// MATCHMAKING RADIUS (UP TO 20 KM)
      const Text(
        'Matchmaking Radius',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      SliderTheme(
  data: SliderTheme.of(context).copyWith(
    valueIndicatorColor: kGreen, // background of label
    valueIndicatorTextStyle: const TextStyle(
      color: Colors.black, // 👈 label text color
      fontWeight: FontWeight.w500,
    ),
    activeTrackColor: kGreen,
    inactiveTrackColor: Colors.grey.shade800,
    thumbColor: kGreen,
  ),
  child: Slider(
    value: radius,
    min: 1,
    max: 20,
    divisions: 19,
    label: '${radius.toInt()} km',
    onChanged: (v) => setState(() => radius = v),
    activeColor: kGreen,
  ),
),


      const SizedBox(height: 12),

      /// BRING YOUR OWN EQUIPMENT
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: bringOwnEquipment,
        activeColor: kGreen,
        title: const Text(
          'Bring Your Own Equipment',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: const Text(
          'Players will bring their own gear',
          style: TextStyle(color: kMuted),
        ),
        onChanged: (v) => setState(() => bringOwnEquipment = v),
      ),

      const SizedBox(height: 12),

      /// SUMMARY CARD
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: kGreen),
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF121212),
        ),
        child: Text(
          splitAndPay
              ? 'Posting for $players Players • ₹$perPersonAmount / person • ${radius.toInt()} km'
              : 'Posting for $players Players • Host pays ₹$baseSlotPrice • ${radius.toInt()} km'
              '${bringOwnEquipment ? ' • BYO Equipment' : ''}',
          style: const TextStyle(
            color: kGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
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
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: kCardColor, // Spotify dark surface
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade800),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// HEADER
        Row(
          children: const [
            Icon(
              Icons.info_outline,
              color: kGreen,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'Venue Policy',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        /// POLICY ITEMS
        _policyItem('Non-refundable within 4 hours'),
        _policyItem('Steel studs are prohibited'),
      ],
    ),
  );
}

Widget _policyItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(
            Icons.circle,
            size: 6,
            color: kMuted,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: kMuted,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}

void _onPayPressed() {
  // This is where Razorpay / Stripe / Cashfree goes later
  debugPrint('Proceeding to pay ₹$_totalAmount');
  Navigator.of(context).push(MaterialPageRoute(builder: (_){return BookingConfirmationScreen();}));
}

  // ------------------------------------------------------------
  // CTA BAR
Widget _bottomBar() {
  final bool enabled = _isReadyToPay;

  return ClipRRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.8),
          border: Border(
            top: BorderSide(color: Color(0xFF1A1A1A)),
          ),
        ),
        child: ElevatedButton(
          onPressed: enabled ? _onPayPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? kGreen : const Color(0xFF2A2A2A),
            foregroundColor: Colors.black,
            elevation: enabled ? 2 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            enabled ? 'Pay ₹$_totalAmount' : 'Complete details to pay',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: enabled ? Colors.black : kMuted,
            ),
          ),
        ),
      ),
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
    initialTime: isStart
        ? (_startTime ?? const TimeOfDay(hour: 8, minute: 0))
        : (_endTime ?? const TimeOfDay(hour: 9, minute: 0)),
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
      if (_endTime == null || _endTime!.hour <= _startTime!.hour) {
        _endTime = TimeOfDay(
          hour: (_startTime!.hour + 1).clamp(0, 23),
          minute: 0,
        );
      }
    } else {
      /// 🚫 BLOCK INVALID END TIME
      if (_startTime != null && selected.hour <= _startTime!.hour) {
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
