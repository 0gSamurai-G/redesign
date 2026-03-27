

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:redesign/view/USER/Home/Friends/friends_chat.dart';
import 'package:redesign/view/USER/Home/Friends/friends_requests.dart';

const kBg = Color(0xFF000000);
const kSurface = Color(0xFF0E0E0E);
const kGreen = Color(0xFF1DB954);
const kMuted = Colors.white70;
const kBlue = Color(0xFF4DA3FF);
const kAmber = Color(0xFFFFC107);

class FriendsHubScreen extends StatefulWidget {
  const FriendsHubScreen({super.key});

  @override
  State<FriendsHubScreen> createState() => _FriendsHubScreenState();
}

class _FriendsHubScreenState extends State<FriendsHubScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  FriendsController get _ctrl => Get.find<FriendsController>();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ── Main scroll content ──
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const _FriendsAppBar(),
                SliverToBoxAdapter(
                    child: _SearchBar(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: (q) => _ctrl.searchUsers(q),
                  onClear: () {
                    _searchController.clear();
                    _ctrl.searchUsers('');
                    _searchFocusNode.unfocus();
                  },
                )),
                SliverToBoxAdapter(child: _OnlineNowSection()),
                SliverToBoxAdapter(child: _MessagesListSection()),
                SliverToBoxAdapter(child: _BuildSquadCTA()),
                SliverToBoxAdapter(child: _SuggestedPlayersSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),

            // ── Search results overlay ──
            Obx(() {
              if (!_ctrl.isSearching.value ||
                  _ctrl.searchResults.isEmpty) {
                return const SizedBox.shrink();
              }
              return Positioned(
                top: 120, // below app bar + search bar
                left: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _ctrl.searchUsers('');
                    _searchFocusNode.unfocus();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: _SearchResultsList(
                      results: _ctrl.searchResults,
                      onAdd: (user) => _ctrl.sendFriendRequest(user),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════
//  APP BAR
// ═══════════════════════════════════
class _FriendsAppBar extends StatelessWidget {
  const _FriendsAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Friends Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Play together. Stay connected.',
                    style: TextStyle(color: kMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════
//  SEARCH BAR
// ═══════════════════════════════════
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            icon: const Icon(Icons.search, color: kMuted),
            hintText: 'Find friends, squads, or nearby players...',
            hintStyle: const TextStyle(color: kMuted),
            border: InputBorder.none,
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (_, value, __) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.close, color: kMuted, size: 20),
                  onPressed: onClear,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════
//  SEARCH RESULTS OVERLAY
// ═══════════════════════════════════
class _SearchResultsList extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final Function(Map<String, dynamic>) onAdd;

  const _SearchResultsList({required this.results, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.55,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withAlpha(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(180),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: results.length,
            separatorBuilder: (_, __) =>
                const Divider(color: Colors.white10, height: 1),
            itemBuilder: (_, i) {
              final user = results[i];
              return _SearchResultTile(user: user, onAdd: () => onAdd(user));
            },
          ),
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onAdd;

  const _SearchResultTile({required this.user, required this.onAdd});

  @override
  State<_SearchResultTile> createState() => _SearchResultTileState();
}

class _SearchResultTileState extends State<_SearchResultTile> {
  bool _tapped = false;

  @override
  Widget build(BuildContext context) {
    final name = widget.user['fullName'] ?? 'Unknown';
    final pic = widget.user['profileImageUrl'] ?? '';
    final alreadyFriend = widget.user['alreadyFriend'] == true;
    final alreadyRequested = widget.user['alreadyRequested'] == true;
    final isPublic = widget.user['isPublicProfile'] ?? true;

    String buttonLabel;
    Color buttonColor;
    Color textColor;
    bool enabled;

    if (alreadyFriend || _tapped) {
      buttonLabel = alreadyFriend ? 'Friends' : (isPublic ? 'Added' : 'Sent');
      buttonColor = kGreen.withAlpha(38);
      textColor = kGreen;
      enabled = false;
    } else if (alreadyRequested) {
      buttonLabel = 'Sent';
      buttonColor = kGreen.withAlpha(38);
      textColor = kGreen;
      enabled = false;
    } else {
      buttonLabel = isPublic ? 'Add' : 'Request';
      buttonColor = kGreen;
      textColor = Colors.black;
      enabled = true;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: pic.isNotEmpty
                ? CachedNetworkImageProvider(pic) as ImageProvider
                : null,
            backgroundColor: kSurface,
            child: pic.isEmpty
                ? const Icon(Icons.person, color: kMuted)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: enabled
                ? () {
                    setState(() => _tapped = true);
                    widget.onAdd();
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                buttonLabel,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════
//  ONLINE NOW
// ═══════════════════════════════════
class _OnlineNowSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<FriendsController>();

    return Obx(() {
      final onlineFriends = ctrl.friends.take(4).toList();

      if (onlineFriends.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              'Online Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            height: 110,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: onlineFriends.length,
              itemBuilder: (_, i) => _OnlineAvatar(
                name: onlineFriends[i].fullName.split(' ').first,
                imageUrl: onlineFriends[i].profileImageUrl,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _OnlineAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;

  const _OnlineAvatar({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kGreen, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: kGreen.withAlpha(76),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: imageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(imageUrl) as ImageProvider
                      : null,
                  backgroundColor: kSurface,
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: kGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: kBg, width: 2.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════
//  BUILD SQUAD CTA
// ═══════════════════════════════════
class _BuildSquadCTA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: kGreen,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Build a New Squad',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Book turfs faster with your team.',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text('Start Now'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════
//  SUGGESTED PLAYERS
// ═══════════════════════════════════
class _SuggestedPlayersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SectionHeader('Suggested Players', action: 'View Map'),
        _SuggestedPlayerCard(
          name: 'Rahul S.',
          level: 'Intermediate',
          meta: '500m · Football',
        ),
        _SuggestedPlayerCard(
          name: 'Sneha K.',
          level: 'Pro',
          meta: '1.2km · Badminton',
        ),
      ],
    );
  }
}

class _SuggestedPlayerCard extends StatelessWidget {
  final String name;
  final String level;
  final String meta;

  const _SuggestedPlayerCard({
    required this.name,
    required this.level,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/women/44.jpg',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      _LevelBadge(level),
                    ],
                  ),
                  Text(
                    meta,
                    style: const TextStyle(color: kMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_add_alt, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final String label;
  const _LevelBadge(this.label);

  @override
  Widget build(BuildContext context) {
    final color = label == 'Pro' ? kGreen : kMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(38),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;

  const _SectionHeader(this.title, {this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          if (action != null)
            Text(
              action!,
              style: const TextStyle(
                color: kGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════
//  MESSAGES LIST (DYNAMIC)
// ═══════════════════════════════════
class _MessagesListSection extends StatelessWidget {
  const _MessagesListSection();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<FriendsController>();

    return Obx(() {
      final requestCount = ctrl.pendingRequests.length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'MESSAGES',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.2,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const FriendsRequestsScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      '$requestCount Requests',
                      style: const TextStyle(
                        color: kGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Show friends as message list
          Obx(() {
            final friendsList = ctrl.friends;
            if (friendsList.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Center(
                  child: Text(
                    'No friends yet. Search and add players!',
                    style: TextStyle(color: kMuted, fontSize: 14),
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: friendsList.length,
              itemBuilder: (_, i) {
                final f = friendsList[i];
                return _MessageListTile(
                  name: f.fullName,
                  subtitle: 'Tap to chat',
                  isNew: false,
                  hasDot: f.isOnline,
                  imageUrl: f.profileImageUrl,
                  email: f.email,
                  isOnline: f.isOnline,
                );
              },
            );
          }),
        ],
      );
    });
  }
}

class _MessageListTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool isNew;
  final bool hasDot;
  final String imageUrl;
  final String email;
  final bool isOnline;

  const _MessageListTile({
    required this.name,
    required this.subtitle,
    required this.isNew,
    required this.hasDot,
    required this.imageUrl,
    required this.email,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatScreen(
            friendEmail: email,
            friendName: name,
            friendPic: imageUrl,
            isOnline: isOnline,
          ),
        ));
      },
      onLongPress: () {
        _showRemoveFriendSheet(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: imageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(imageUrl) as ImageProvider
                      : null,
                  backgroundColor: kSurface,
                ),
                if (hasDot)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: kGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: kBg, width: 2.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isNew ? kGreen : kMuted,
                      fontSize: 14,
                      fontWeight: isNew ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void _showRemoveFriendSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('Remove $name?', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('This will delete all messages permanently.', style: TextStyle(color: kMuted, fontSize: 13)),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.person_remove, color: Colors.redAccent),
              title: const Text('Remove Friend', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                Get.find<FriendsController>().removeFriend(email);
                Get.snackbar('Removed', '$name removed from friends', backgroundColor: Colors.redAccent.withAlpha(50), colorText: Colors.white);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
