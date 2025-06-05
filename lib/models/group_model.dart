import 'package:isar/isar.dart';

part 'group_model.g.dart';

@Collection()
class Group {
  Id id = Isar.autoIncrement;

  late String name;

  // A qué carpeta pertenece (null si es raíz)
  int? parentFolderId;

  late DateTime createdAt;
  late DateTime updatedAt;
}
