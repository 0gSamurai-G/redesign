import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';

const _kBg = Color(0xFF000000);
const _kCardBg = Color(0xFF1A1A1A);
const _kGreen = Color(0xFF1DB954);
const _kMuted = Colors.white70;

class FriendsRequestsScreen extends StatelessWidget {
  const FriendsRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<FriendsController>();

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ──
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: _kGreen,
                      size: 26,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Requests',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Obx(() => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: _kGreen, width: 1.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${ctrl.pendingRequests.length} NEW',
                          style: const TextStyle(
                            color: _kGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Divider ──
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Colors.white12, height: 1),
            ),

            const SizedBox(height: 20),

            // ── Section Title ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    'PENDING REQUESTS',
                    style: TextStyle(
                      color: _kMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white10,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Request Cards ──
            Expanded(
              child: Obx(() {
                final requests = ctrl.pendingRequests;

                if (requests.isEmpty) {
                  return const Center(
                    child: Text(
                      'No pending requests',
                      style: TextStyle(color: _kMuted, fontSize: 15),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    return _RequestCard(
                      request: req,
                      onApprove: () => ctrl.approveFriendRequest(req),
                      onDecline: () => ctrl.declineRequest(req),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Request Card
// ─────────────────────────────────────────────
class _RequestCard extends StatefulWidget {
  final FriendRequestModel request;
  final VoidCallback onApprove;
  final VoidCallback onDecline;

  const _RequestCard({
    required this.request,
    required this.onApprove,
    required this.onDecline,
  });

  @override
  State<_RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<_RequestCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  bool _approved = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onApprove() {
    setState(() => _approved = true);
    widget.onApprove();
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _kCardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(10)),
          ),
          child: Row(
            children: [
              // ── Avatar ──
              CircleAvatar(
                radius: 30,
                backgroundImage: req.fromProfilePic.isNotEmpty
                    ? CachedNetworkImageProvider(req.fromProfilePic)
                        as ImageProvider
                    : null,
                backgroundColor: const Color(0xFF0E0E0E),
                child: req.fromProfilePic.isEmpty
                    ? const Icon(Icons.person, color: _kMuted)
                    : null,
              ),

              const SizedBox(width: 16),

              // ── Name ──
              Expanded(
                child: Text(
                  req.fromName.isNotEmpty ? req.fromName : req.fromEmail,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // ── Approve Button ──
              GestureDetector(
                onTapDown: (_) => _controller.forward(),
                onTapUp: (_) {
                  _controller.reverse();
                  if (!_approved) _onApprove();
                },
                onTapCancel: () => _controller.reverse(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _approved ? _kGreen.withAlpha(38) : _kGreen,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: _approved
                        ? []
                        : [
                            BoxShadow(
                              color: _kGreen.withAlpha(89),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _approved
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            key: ValueKey('approved'),
                            children: [
                              Icon(Icons.check, color: _kGreen, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Added',
                                style: TextStyle(
                                  color: _kGreen,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'Approve',
                            key: ValueKey('approve'),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
