class SyncAction {
  String idempotencyKey;
  String type;
  Map<String, dynamic> payload;
  int retryCount;

  SyncAction({
    required this.idempotencyKey,
    required this.type,
    required this.payload,
    this.retryCount = 0,
  });
}