import 'package:hive_flutter/hive_flutter.dart';

class LocalDB {
  static Box? noteBox;
  static Box? queueBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    noteBox = await Hive.openBox("notes");
    queueBox = await Hive.openBox("queue");
  }
}