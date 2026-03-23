class Note {
  String id;
  String content;
  DateTime updatedAt;
  bool isSynced;
  bool isLiked; 

  Note({
    required this.id,
    required this.content,
    required this.updatedAt,
    this.isSynced = false,
    this.isLiked = false,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "updatedAt": updatedAt.toIso8601String(),
        "isSynced": isSynced,
        "isLiked": isLiked,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        content: json["content"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        isSynced: json["isSynced"] ?? false,
        isLiked: json["isLiked"] ?? false,
      );
}