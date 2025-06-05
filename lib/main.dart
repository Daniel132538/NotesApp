import 'package:flutter/material.dart';
import 'package:notesapp/widgets/app_entry_point.dart';
import 'package:easy_localization/easy_localization.dart';

import 'models/folder_model.dart';
import 'models/group_model.dart';
import 'models/message_model.dart'; // si lo llamaste así
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([
    FolderSchema,
    GroupSchema,
    MessageSchema,
  ], directory: dir.path);

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('es'), Locale('en')],
      path: 'assets/langs',
      fallbackLocale: Locale('es'),
      child: AppEntryPoint(isar: isar),
    ),
  );
}
