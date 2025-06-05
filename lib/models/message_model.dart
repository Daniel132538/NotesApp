import 'package:isar/isar.dart';

part 'message_model.g.dart';

@Collection()
class Message {
  Id id = Isar.autoIncrement;

  late int groupId; // Relación con el grupo

  late String content;

  late DateTime createdAt;

  bool edited = false;
}
