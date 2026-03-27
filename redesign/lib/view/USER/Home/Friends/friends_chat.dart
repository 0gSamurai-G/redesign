import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
// Note: Location messages use simple text or url launch for simplicity as Google Maps here would be heavy for a chat bubble

import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/chat_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:intl/intl.dart';

const _kGreen = Color(0xFF1DB954);
const _kBg = Color(0xFF121212);
const _kSurface = Color(0xFF222222);
const _kMuted = Colors.white38;

class ChatScreen extends StatefulWidget {
  final String friendEmail;
  final String friendName;
  final String friendPic;
  final bool isOnline;

  const ChatScreen({
    super.key,
    required this.friendEmail,
    required this.friendName,
    required this.friendPic,
    required this.isOnline,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _msgController = TextEditingController();
  late final ChatController _ctrl;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<ChatController>();
    _ctrl.initChat(widget.friendEmail);

    ever(_ctrl.messages, (_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Stack(
          children: [
            // 🔥 BACKGROUND DOODLE
            Positioned.fill(
              child: Opacity(
                opacity: 0.15,
                child: CachedNetworkImage(
                  imageUrl: "https://camo.githubusercontent.com/c42c83df2fd1e442ef1e0ed69cc20d21f65308fc2f0dca2a8035360738d49c8c/68747470733a2f2f7765622e77686174736170702e636f6d2f696d672f62672d636861742d74696c652d6461726b5f61346265353132653731393562366237333364393131306234303866303735642e706e67",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                /// 🔥 APP BAR
                _ChatAppBar(
                  name: widget.friendName.isNotEmpty ? widget.friendName : widget.friendEmail,
                  pic: widget.friendPic,
                  isOnline: widget.isOnline,
                ),

                /// 🔥 CHAT LIST
                Expanded(
                  child: Obx(() {
                    if (_ctrl.messages.isEmpty) {
                      return const Center(
                        child: Text(
                          "Say hi to start the conversation! 👋",
                          style: TextStyle(color: _kMuted, fontSize: 15),
                        ),
                      );
                    }

                    return ListView.builder(
                      key: const PageStorageKey("chat_list"),
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      reverse: true, // Auto-scroll to bottom behavior
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      itemCount: _ctrl.messages.length,
                      itemBuilder: (context, i) {
                        final msg = _ctrl.messages[i];
                        final isMe = msg.senderEmail == _ctrl.myEmail;
                        // Format time
                        final timeStr = DateFormat('HH:mm').format(msg.timestamp);
                        return _MessageBubble(
                          key: ValueKey(msg.id),
                          msg: msg, 
                          isMe: isMe, 
                          timeStr: timeStr,
                        );
                      },
                    );
                  }),
                ),

                /// 🔥 INPUT BAR
                _buildInputBar(context),
              ],
            ),

            // 🔥 UPLOAD OVERLAY
            Obx(() {
              if (!_ctrl.isUploadingMedia.value) return const SizedBox.shrink();
              return Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: _kGreen),
                        SizedBox(height: 16),
                        Text("Sending media...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
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

  Widget _buildInputBar(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.white60),
                      onPressed: () {}, // Optional
                    ),
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        style: const TextStyle(color: Colors.white),
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 5,
                        onChanged: (val) {
                          setState(() => _isTyping = val.trim().isNotEmpty);
                        },
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: _kMuted, fontSize: 16),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: Colors.white60),
                      onPressed: () => _showAttachmentSheet(context),
                    ),
                    if (!_isTyping)
                      IconButton(
                        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white60),
                        onPressed: () => _ctrl.sendMedia(ImageSource.camera),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Send/Mic Button
            GestureDetector(
              onTap: () {
                if (_isTyping) {
                  _ctrl.sendText(_msgController.text);
                  _msgController.clear();
                  setState(() => _isTyping = false);
                  _scrollToBottom();
                }
              },
              onLongPressStart: (_) {
                if (!_isTyping) _ctrl.startRecording();
              },
              onLongPressEnd: (_) {
                if (!_isTyping) _ctrl.stopRecording();
              },
              child: Obx(() {
                final isRec = _ctrl.isRecording.value;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: isRec ? 56 : 48,
                  width: isRec ? 56 : 48,
                  decoration: BoxDecoration(
                    color: _isTyping ? _kGreen : (isRec ? Colors.redAccent : _kGreen),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _isTyping ? Icons.send : (isRec ? Icons.stop : Icons.mic),
                      color: isRec ? Colors.white : Colors.black,
                      size: isRec ? 30 : 22,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2B2B),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _AttachmentIcon(
                  icon: Icons.image,
                  color: Colors.purpleAccent,
                  label: "Gallery",
                  onTap: () {
                    Navigator.pop(context);
                    _ctrl.sendMedia(ImageSource.gallery);
                  },
                ),
                _AttachmentIcon(
                  icon: Icons.videocam,
                  color: Colors.pinkAccent,
                  label: "Video",
                  onTap: () {
                    Navigator.pop(context);
                    _ctrl.sendMedia(ImageSource.gallery, isVideo: true);
                  },
                ),
                _AttachmentIcon(
                  icon: Icons.location_on,
                  color: _kGreen,
                  label: "Location",
                  onTap: () {
                    Navigator.pop(context);
                    _ctrl.sendLocation();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _AttachmentIcon({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════
//  APP BAR
// ═══════════════════════════════════
class _ChatAppBar extends StatelessWidget {
  final String name;
  final String pic;
  final bool isOnline;

  const _ChatAppBar({required this.name, required this.pic, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: _kSurface,
                backgroundImage: pic.isNotEmpty
                    ? CachedNetworkImageProvider(pic) as ImageProvider
                    : null,
                child: pic.isEmpty ? const Icon(Icons.person, color: _kMuted) : null,
              ),
              if (isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _kGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                isOnline ? "ONLINE" : "OFFLINE",
                style: TextStyle(
                  color: isOnline ? _kGreen : _kMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {}, // Not requested yet
            icon: const Icon(Icons.videocam_outlined, color: Colors.white, size: 26),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_outlined, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════
//  MESSAGE BUBBLE
// ═══════════════════════════════════
class _MessageBubble extends StatelessWidget {
  final ChatMessageModel msg;
  final bool isMe;
  final String timeStr;

  const _MessageBubble({
    Key? key,
    required this.msg, 
    required this.isMe, 
    required this.timeStr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            _buildContent(context),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(timeStr, style: const TextStyle(color: _kMuted, fontSize: 11)),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    msg.isRead ? Icons.done_all : Icons.done,
                    size: 14,
                    color: msg.isRead ? Colors.blue : _kMuted,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (msg.type) {
      case 'text':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isMe ? _kGreen : _kSurface,
            borderRadius: BorderRadius.circular(20).copyWith(
              bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(20),
              bottomLeft: !isMe ? const Radius.circular(4) : const Radius.circular(20),
            ),
          ),
          child: Text(
            msg.content,
            style: TextStyle(
              color: isMe ? Colors.black : Colors.white,
              fontSize: 16,
              fontWeight: isMe ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        );
      case 'image':
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenImage(url: msg.content),
              ),
            );
          },
          child: Hero(
            tag: msg.content,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                  maxHeight: 300,
                ),
                child: CachedNetworkImage(
                  imageUrl: msg.content,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    height: 200, width: 250, color: _kSurface,
                    child: const Icon(Icons.error, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        );
      case 'audio':
        return _AudioBubble(url: msg.content, isMe: isMe);
      case 'video':
        return _VideoBubble(url: msg.content);
      case 'location':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isMe ? _kGreen.withOpacity(0.2) : _kSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isMe ? _kGreen : Colors.transparent),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, color: isMe ? _kGreen : Colors.redAccent),
              const SizedBox(width: 8),
              const Text("Location Pin", style: TextStyle(color: Colors.white)),
            ],
          ),
        );
      default:
        return Container();
    }
  }
}

// ═══════════════════════════════════
//  AUDIO PLAYER BUBBLE
// ═══════════════════════════════════
class _AudioBubble extends StatefulWidget {
  final String url;
  final bool isMe;

  const _AudioBubble({required this.url, required this.isMe});

  @override
  State<_AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<_AudioBubble> with AutomaticKeepAliveClientMixin {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _playPause() async {
    try {
      if (_isPlaying) {
        await _player.pause();
      } else {
        await _player.stop();
        await _player.play(UrlSource(widget.url));
      }
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isMe ? _kGreen.withOpacity(0.9) : _kSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: widget.isMe ? Colors.white : _kGreen,
            child: IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                  color: widget.isMe ? Colors.black : Colors.black),
              onPressed: _playPause,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 120, // fixed waveform width
            height: 30,
            alignment: Alignment.center,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 2,
              ),
              child: Slider(
                value: _position.inSeconds.toDouble(),
                max: _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0,
                activeColor: widget.isMe ? Colors.black : _kGreen,
                inactiveColor: Colors.black26,
                onChanged: (val) {
                  _player.seek(Duration(seconds: val.toInt()));
                },
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            "${_position.inSeconds}s",
            style: TextStyle(
                color: widget.isMe ? Colors.black87 : Colors.white70,
                fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════
//  VIDEO PLAYER BUBBLE
// ═══════════════════════════════════
class _VideoBubble extends StatefulWidget {
  final String url;
  const _VideoBubble({required this.url});

  @override
  State<_VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<_VideoBubble> with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) setState(() => _initialized = true);
      });

    // Detect video completion to reset play icon
    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration &&
          !_controller.value.isPlaying) {
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void deactivate() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_initialized) {
      return Container(
        height: 200,
        width: 250,
        decoration: BoxDecoration(color: _kSurface, borderRadius: BorderRadius.circular(16)),
        child: const Center(
          child: CircularProgressIndicator(color: _kGreen),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FullScreenVideo(url: widget.url),
            ),
          );
        },
        child: Hero(
          tag: 'video_${widget.url}',
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
              maxHeight: 300,
            ),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════
//  FULLSCREEN IMAGE VIEWER
// ═══════════════════════════════════
class FullScreenImage extends StatelessWidget {
  final String url;

  const FullScreenImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: url,
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════
//  FULLSCREEN VIDEO PLAYER
// ═══════════════════════════════════
class FullScreenVideo extends StatefulWidget {
  final String url;

  const FullScreenVideo({super.key, required this.url});

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _controller.value.isPlaying
          ? _controller.pause()
          : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        onTap: _togglePlay,
        child: Center(
          child: Hero(
            tag: 'video_${widget.url}',
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller),
                  if (!_controller.value.isPlaying)
                    const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 80,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
