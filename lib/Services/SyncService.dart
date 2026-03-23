import 'dart:developer';

import 'package:notesassignment/Services/ApiService.dart';
import 'package:notesassignment/Services/LocalDb.dart';

class SyncService {
  final api = ApiService();

  Future<void> processQueue() async {
    final queue = LocalDB.queueBox!;

    int successCount = 0;
    int failCount = 0;    
    log("🚀 SYNC STARTED");
    log("QUEUE SIZE BEFORE: ${queue.length}");

    for (int i = 0; i < queue.length; i++) {
      var action = Map<String, dynamic>.from(queue.getAt(i));

      try {
        final payload =
            Map<String, dynamic>.from(action["payload"]);

        /// 🔥 Handle all action types
        if (action["type"] == "add_note" ||
            action["type"] == "edit_note" ||
            action["type"] == "toggle_like") {

          final updatedPayload = {
            ...payload,
            "isSynced": true,
          };

          ///Idempotent API call
          await api.addNote(updatedPayload);
        }

        /// ✅ Success
        successCount++;

        log("✅ SYNC SUCCESS: ${action["idempotencyKey"]}");

        /// 🔥 Update local DB
        await LocalDB.noteBox!.put(
          payload["id"],
          {
            ...payload,
            "isSynced": true,
          },
        );

        /// 🔥 Remove from queue
        await queue.deleteAt(i);
        i--;
      } catch (e) {
        failCount++;

        log("❌ ERROR: $e");

        /// 🔥 Retry logic
        action["retryCount"] =
            (action["retryCount"] ?? 0) + 1;

        await queue.putAt(i, action);

        log("SYNC FAIL: ${action["idempotencyKey"]}");

        /// 🔥 Max retry = 1
        if (action["retryCount"] > 1) {
          log("FAILED AFTER RETRY: ${action["idempotencyKey"]}");
          continue;
        }

        int retry = action["retryCount"] as int;

        /// 🔥 Basic backoff
        await Future.delayed(
          Duration(seconds: 2 * retry),
        );
      }
    }

    log("QUEUE SIZE AFTER: ${queue.length}");

    /// 🔥 Observability counters
    log("📊 SUCCESS COUNT: $successCount");
    log("📊 FAIL COUNT: $failCount");

    log("🏁 SYNC COMPLETED");
  }
}