import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';

import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Friends_SQF/friendsSqflite.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

class ChatController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();
  final _audioRecorder = AudioRecorder();

  // ── State ──
  late String dmDocId;
  late String friendEmail;
  String myEmail = '';

  final messages = <ChatMessageModel>[].obs;
  final isSendingText = false.obs;
  final isUploadingMedia = false.obs;
  final isRecording = false.obs;

  StreamSubscription? _msgSub;
  String? _recordPath;
  DateTime? _recordingStartTime;

  // Init is called explicitly when ChatScreen is opened
  Future<void> initChat(String friendEmailParam) async {
    myEmail = await UserPreferences.getDocId() ?? '';
    if (myEmail.isEmpty) return;

    friendEmail = friendEmailParam;
    final sorted = [myEmail, friendEmail]..sort();
    dmDocId = sorted.join('_');

    // Load fast from SQFlite
    final localMsgs = await FriendsSqflite.getMessagesByDmId(dmDocId);
    messages.assignAll(localMsgs);

    // Listen to live stream
    _listenToMessages();
  }

  @override
  void onClose() {
    _msgSub?.cancel();
    _audioRecorder.dispose();
    super.onClose();
  }

  // ═══════════════════════════════════
  //  STREAM DATA
  // ═══════════════════════════════════

  void _listenToMessages() {
    _msgSub?.cancel();
    _msgSub = _firestore
        .collection('Direct_Message')
        .doc(dmDocId)
        .collection('Chats')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) async {
      final newMsgs = snapshot.docs.map((doc) {
        return ChatMessageModel.fromMap(doc.id, doc.data());
      }).toList();

      messages.assignAll(newMsgs);

      // Sync to local DB in background
      await FriendsSqflite.clearAndInsertMessages(dmDocId, newMsgs);
    }, onError: (e) {
      debugPrint('🔴 [ChatController] Sync error: $e');
    });
  }

  // ═══════════════════════════════════
  //  SEND MESSAGES
  // ═══════════════════════════════════

  Future<void> sendText(String content) async {
    if (content.trim().isEmpty) return;
    isSendingText.value = true;
    await _sendMessage('text', content.trim());
    isSendingText.value = false;
  }

  Future<void> sendLocation() async {
    isUploadingMedia.value = true;
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await _sendMessage('location', '${position.latitude},${position.longitude}');
    } catch (e) {
      Get.snackbar('Location Error', 'Could not fetch your location.');
    } finally {
      isUploadingMedia.value = false;
    }
  }

  Future<void> sendMedia(ImageSource source, {bool isVideo = false}) async {
    isUploadingMedia.value = true;
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = isVideo
          ? await picker.pickVideo(source: source)
          : await picker.pickImage(source: source, imageQuality: 60);

      if (file == null) {
        debugPrint('🟡 [Chat] No file selected.');
        return;
      }

      final localFile = File(file.path);
      if (!await localFile.exists()) {
        debugPrint('🔴 [Chat] Selected file does not exist: ${file.path}');
        return;
      }

      final downloadUrl = await _uploadToStorage(
          localFile, isVideo ? 'videos' : 'images');
      
      if (downloadUrl.isNotEmpty) {
        await _sendMessage(isVideo ? 'video' : 'image', downloadUrl);
      }
    } catch (e, stack) {
      debugPrint('🔴 [Chat] Media upload exception: $e');
      debugPrint(stack.toString());
      Get.snackbar('Error', 'Failed to send media: $e');
    } finally {
      isUploadingMedia.value = false;
    }
  }

  Future<void> sendAudioFile() async {
    // Left as placeholder: would use file_picker to pick an audio file
    // Implementation is exactly the same as sendMedia (pick file -> upload -> _sendMessage)
    Get.snackbar('Coming Soon', 'Audio file picker requires file_picker dependency');
  }

  // ═══════════════════════════════════
  //  AUDIO RECORDING (MIC)
  // ═══════════════════════════════════

  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        _recordPath = '${tempDir.path}/audio_${_uuid.v4()}.m4a';
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: _recordPath!,
        );
        _recordingStartTime = DateTime.now();
        isRecording.value = true;
      }
    } catch (e) {
      debugPrint('🔴 [Chat] Audio record start error: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      isRecording.value = false;

      // Check for zero-second or accidental taps
      if (_recordingStartTime != null) {
        final duration = DateTime.now().difference(_recordingStartTime!);
        if (duration.inMilliseconds < 1000) {
          debugPrint('🟡 [Chat] Recording too short, discarding');
          if (path != null && File(path).existsSync()) {
            File(path).deleteSync();
          }
          return;
        }
      }

      if (path != null && File(path).existsSync()) {
        isUploadingMedia.value = true;
        final downloadUrl = await _uploadToStorage(File(path), 'audio');
        await _sendMessage('audio', downloadUrl);
        isUploadingMedia.value = false;
      }
    } catch (e) {
      debugPrint('🔴 [Chat] Audio record stop error: $e');
      isRecording.value = false;
      isUploadingMedia.value = false;
    }
  }

  Future<void> cancelRecording() async {
    await _audioRecorder.stop();
    isRecording.value = false;
    if (_recordPath != null && File(_recordPath!).existsSync()) {
      File(_recordPath!).deleteSync();
    }
  }

  // ═══════════════════════════════════
  //  CORE HELPERS
  // ═══════════════════════════════════

  Future<void> _sendMessage(String type, String content) async {
    if (myEmail.isEmpty) return;
    
    final id = _uuid.v4();
    final msg = ChatMessageModel(
      id: id,
      senderEmail: myEmail,
      type: type,
      content: content,
    );

    // Save to Firestore subcollection
    final chatRef = _firestore
        .collection('Direct_Message')
        .doc(dmDocId)
        .collection('Chats')
        .doc(id);

    await chatRef.set(msg.toMap());

    // Update parent DM doc with last message
    await _firestore.collection('Direct_Message').doc(dmDocId).update({
      'lastMessage': type == 'text' ? content : 'Sent a $type',
      'lastMessageAt': FieldValue.serverTimestamp(),
    });

    // Optimistically insert locally so UI bounces fast
    await FriendsSqflite.insertMessage(msg, dmDocId);
  }

  Future<String> _uploadToStorage(File file, String folder) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${_uuid.v4()}';
    // Path matches standard format: Direct_Message/alice_bob/images/123_xyz.png
    final refPath = 'Direct_Message/$dmDocId/$folder/$fileName';
    final storageRef = _storage.ref().child(refPath);

    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }
}
