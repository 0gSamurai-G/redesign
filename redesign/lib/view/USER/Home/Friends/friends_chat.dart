import 'dart:io';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Stack(
          children: [
            // 🔥 BACKGROUND DOODLE (Covers full screen)
            Positioned.fill(
              child: Opacity(
                opacity: 0.15,
                child: Image.network(
                  "https://camo.githubusercontent.com/c42c83df2fd1e442ef1e0ed69cc20d21f65308fc2f0dca2a8035360738d49c8c/68747470733a2f2f7765622e77686174736170702e636f6d2f696d672f62672d636861742d74696c652d6461726b5f61346265353132653731393562366237333364393131306234303866303735642e706e67",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      CustomScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          /// 🔥 APP BAR
                          SliverAppBar(
                            pinned: true,
                            backgroundColor: Colors.black.withOpacity(0.8),
                            elevation: 0,
                            automaticallyImplyLeading:
                                false, // Custom back button
                            titleSpacing: 0,
                            title: const _TopBar(),
                          ),

                          /// 🔥 CHAT BODY
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([
                                const SizedBox(height: 10),
                                _dayChip("TODAY"),

                                const SizedBox(height: 10),

                                _receivedMessage(
                                  "Yo! Are we still hitting the court at 6 PM? 🏸",
                                  "14:20",
                                ),

                                _sentMessage(
                                  "Definitely. Just finishing up some work.\nCourt 4 is booked!",
                                  "14:22",
                                ),

                                _voiceMessage("14:23"),

                                _imageMessage("Ready and waiting!", "14:25"),

                                _musicCard(),

                                const SizedBox(height: 20),
                              ]),
                            ),
                          ),
                        ],
                      ),

                      /// 🔥 FLOATING BADGE
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: _buildScrollBadge(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),

                /// 🔥 INPUT BAR
                const _InputBar(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollBadge() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            color: const Color(0xFF1DB954),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1DB954).withOpacity(0.3),
                blurRadius: 15,
              ),
            ],
          ),
          child: const Icon(
            Icons.keyboard_double_arrow_down_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        // Container(
        //   height: 15,
        //   width: 15,
        //   decoration: BoxDecoration(
        //     color: const Color(0xFFC8FFD4),
        //     shape: BoxShape.circle,
        //     border: Border.all(color: Colors.black, width: 1.5),
        //   ),
        //   child: const Center(
        //     child: Text(
        //       "1",
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontSize: 7,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  /// ---------------- UI COMPONENTS ----------------

  Widget _dayChip(String text) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _receivedMessage(String text, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF222222),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Text(time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  Widget _sentMessage(String text, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1DB954),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              time,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.done_all, size: 16, color: Color(0xFF1DB954)),
          ],
        ),
      ],
    );
  }

  Widget _voiceMessage(String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF222222),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF1DB954),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  _waveBar(12),
                  _waveBar(18),
                  _waveBar(24),
                  _waveBar(14),
                  _waveBar(20),
                  _waveBar(12),
                  _waveBar(16),
                  _waveBar(10),
                ],
              ),
              const SizedBox(width: 20),
              const Text(
                "0:14",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        Text(time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  Widget _waveBar(double height) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1.5),
      width: 3.5,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1DB954),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _imageMessage(String caption, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF1DB954).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Image.network(
                  "https://images.unsplash.com/photo-1544911845-1f34a3eb46b1?q=80&w=500&auto=format&fit=crop", // Indoor court
                  height: 320,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Text(
                    caption,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              time,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.done_all, size: 16, color: Color(0xFF1DB954)),
          ],
        ),
      ],
    );
  }

  Widget _musicCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: 300,
          decoration: BoxDecoration(
            color: const Color(0xFF222222),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.amber[300]!, Colors.amber[800]!],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white24,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Smash the Limits",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Stadium Anthems • 2024",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.play_arrow,
                      color: Color(0xFF1DB954),
                      size: 32,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.35,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            "14:28",
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

/// ---------------- TOP BAR ----------------

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),
        Stack(
          children: [
            const CircleAvatar(
              radius: 19,
              backgroundColor: Color(0xFF1DB954),
              child: CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(
                  "https://randomuser.me/api/portraits/men/32.jpg",
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF1DB954),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Deepankar R.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "ONLINE",
              style: TextStyle(
                color: Color(0xFF1DB954),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.call, color: Colors.white, size: 22),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.videocam, color: Color(0xFF1DB954), size: 26),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

/// ---------------- INPUT BAR ----------------

class _InputBar extends StatelessWidget {
  const _InputBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 12),
                  Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.white60,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.attach_file, color: Colors.white60, size: 24),
                  SizedBox(width: 15),
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white60,
                    size: 24,
                  ),
                  SizedBox(width: 15),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 45,
            width: 45,
            decoration: const BoxDecoration(
              color: Color(0xFF1DB954),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic, color: Colors.black, size: 25),
          ),
        ],
      ),
    );
  }
}
