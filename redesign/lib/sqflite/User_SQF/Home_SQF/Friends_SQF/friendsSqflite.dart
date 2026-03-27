import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';

class FriendsSqflite {
  static Database? _db;

  // ── Open / Create ──
  static Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dbPath, 'friends.db'),
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE friends (
            email TEXT PRIMARY KEY,
            fullName TEXT,
            profileImageUrl TEXT,
            isOnline INTEGER DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE friend_requests (
            fromEmail TEXT,
            toEmail TEXT,
            fromName TEXT,
            fromProfilePic TEXT,
            status TEXT,
            timestamp TEXT,
            PRIMARY KEY (fromEmail, toEmail)
          )
        ''');
        await db.execute('''
          CREATE TABLE chat_messages (
            id TEXT PRIMARY KEY,
            dmDocId TEXT,
            senderEmail TEXT,
            type TEXT,
            content TEXT,
            timestamp TEXT,
            isRead INTEGER DEFAULT 0
          )
        ''');
        await db.execute(
            'CREATE INDEX idx_chat_dm ON chat_messages(dmDocId, timestamp)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add isOnline column to friends
          await db.execute(
              'ALTER TABLE friends ADD COLUMN isOnline INTEGER DEFAULT 0');
          // Add chat_messages table
          await db.execute('''
            CREATE TABLE IF NOT EXISTS chat_messages (
              id TEXT PRIMARY KEY,
              dmDocId TEXT,
              senderEmail TEXT,
              type TEXT,
              content TEXT,
              timestamp TEXT,
              isRead INTEGER DEFAULT 0
            )
          ''');
          await db.execute(
              'CREATE INDEX IF NOT EXISTS idx_chat_dm ON chat_messages(dmDocId, timestamp)');
        }
      },
    );
    return _db!;
  }

  // ═══════════════════════════════════
  //  FRIENDS TABLE
  // ═══════════════════════════════════

  static Future<void> insertFriend(FriendModel friend) async {
    final db = await database;
    await db.insert('friends', friend.toSqfliteMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<FriendModel>> getAllFriends() async {
    final db = await database;
    final maps = await db.query('friends');
    return maps.map((m) => FriendModel.fromSqfliteMap(m)).toList();
  }

  static Future<void> deleteFriend(String email) async {
    final db = await database;
    await db.delete('friends', where: 'email = ?', whereArgs: [email]);
  }

  static Future<void> clearAndInsertFriends(List<FriendModel> friends) async {
    final db = await database;
    final batch = db.batch();
    batch.delete('friends');
    for (final f in friends) {
      batch.insert('friends', f.toSqfliteMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  // ═══════════════════════════════════
  //  FRIEND REQUESTS TABLE
  // ═══════════════════════════════════

  static Future<void> insertRequest(FriendRequestModel req) async {
    final db = await database;
    await db.insert('friend_requests', req.toSqfliteMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<FriendRequestModel>> getAllRequests() async {
    final db = await database;
    final maps = await db.query('friend_requests');
    return maps.map((m) => FriendRequestModel.fromSqfliteMap(m)).toList();
  }

  static Future<void> deleteRequest(String fromEmail, String toEmail) async {
    final db = await database;
    await db.delete('friend_requests',
        where: 'fromEmail = ? AND toEmail = ?',
        whereArgs: [fromEmail, toEmail]);
  }

  static Future<void> clearAndInsertRequests(
      List<FriendRequestModel> requests) async {
    final db = await database;
    final batch = db.batch();
    batch.delete('friend_requests');
    for (final r in requests) {
      batch.insert('friend_requests', r.toSqfliteMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  // ═══════════════════════════════════
  //  CHAT MESSAGES TABLE
  // ═══════════════════════════════════

  static Future<void> insertMessage(
      ChatMessageModel msg, String dmDocId) async {
    final db = await database;
    await db.insert('chat_messages', msg.toSqfliteMap(dmDocId),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<ChatMessageModel>> getMessagesByDmId(
      String dmDocId) async {
    final db = await database;
    final maps = await db.query(
      'chat_messages',
      where: 'dmDocId = ?',
      whereArgs: [dmDocId],
      orderBy: 'timestamp ASC',
    );
    return maps.map((m) => ChatMessageModel.fromSqfliteMap(m)).toList();
  }

  static Future<void> clearAndInsertMessages(
      String dmDocId, List<ChatMessageModel> messages) async {
    final db = await database;
    final batch = db.batch();
    batch.delete('chat_messages',
        where: 'dmDocId = ?', whereArgs: [dmDocId]);
    for (final m in messages) {
      batch.insert('chat_messages', m.toSqfliteMap(dmDocId),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  static Future<void> deleteMessagesByDmId(String dmDocId) async {
    final db = await database;
    await db.delete('chat_messages',
        where: 'dmDocId = ?', whereArgs: [dmDocId]);
  }
}
