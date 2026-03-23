import 'package:cloud_firestore/cloud_firestore.dart';

class ApiService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addNote(Map<String, dynamic> data) async {
    await firestore
        .collection("notes")
        .doc(data["id"]) // idempotency
        .set(data);
  }
}