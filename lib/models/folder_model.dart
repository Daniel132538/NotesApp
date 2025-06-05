import 'package:isar/isar.dart';

part 'folder_model.g.dart';

@Collection()
class Folder {
  Id id = Isar.autoIncrement;

  late String name;
  int? parentFolderId;

  late DateTime createdAt;
  late DateTime updatedAt;
}
