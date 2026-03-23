import 'package:flutter/material.dart';
import 'package:notesassignment/Models/Note.dart';
import 'package:notesassignment/Services/LocalDb.dart';
import 'package:notesassignment/Services/SyncService.dart';
import 'package:uuid/uuid.dart';

class Notecontroller extends ChangeNotifier {
  List<Note> notes = [];
  final syncService = SyncService();

  bool _isSyncing = false; 

  Future<void> loadNotes() async {
    final box = LocalDB.noteBox!;

    /// 1️⃣ Load local instantly
    notes = box.values
        .map((e) => Note.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    notifyListeners();

    /// 2️⃣ Background sync (without blocking UI)
    _backgroundSync();
  }

  /// 🔥 Background sync (safe)
  Future<void> _backgroundSync() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      await syncService.processQueue();

      /// refresh after sync
      final box = LocalDB.noteBox!;
      notes = box.values
          .map((e) => Note.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Background sync error: $e");
    } finally {
      _isSyncing = false;
    }
  }

  /// Add note (offline-first)
  Future<void> addNote(String content) async {
    final note = Note(
      id: const Uuid().v4(),
      content: content,
      updatedAt: DateTime.now(),
    );

    await LocalDB.noteBox!.put(note.id, note.toJson());

    await LocalDB.queueBox!.add({
      "idempotencyKey": note.id,
      "type": "add_note",
      "payload": note.toJson(),
      "retryCount": 0,
    });

    await loadNotes();
  }

  /// Edit note
  Future<void> editNote(String id, String newContent) async {
    final noteData = LocalDB.noteBox!.get(id);
    final note =
        Note.fromJson(Map<String, dynamic>.from(noteData));

    note.content = newContent;
    note.updatedAt = DateTime.now();
    note.isSynced = false;

    await LocalDB.noteBox!.put(id, note.toJson());

    await LocalDB.queueBox!.add({
      "idempotencyKey": id,
      "type": "edit_note",
      "payload": note.toJson(),
      "retryCount": 0,
    });

    await loadNotes();
  }

  /// Toggle like
  Future<void> toggleLike(String id) async {
    final noteData = LocalDB.noteBox!.get(id);
    final note =
        Note.fromJson(Map<String, dynamic>.from(noteData));

    note.isLiked = !note.isLiked;
    note.isSynced = false;
    note.updatedAt = DateTime.now();

    await LocalDB.noteBox!.put(id, note.toJson());

    await LocalDB.queueBox!.add({
      "idempotencyKey": id,
      "type": "toggle_like",
      "payload": note.toJson(),
      "retryCount": 0,
    });

    await loadNotes();
  }

  /// Manual sync (button)
  Future<void> sync() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      await syncService.processQueue();
      await loadNotes();
    } finally {
      _isSyncing = false;
    }
  }
}