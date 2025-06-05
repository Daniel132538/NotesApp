import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../views/home_view.dart';
import 'package:isar/isar.dart';

class MyApp extends StatelessWidget {
  final Isar isar;
  const MyApp({super.key, required this.isar});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app_title'.tr(),
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeView(isar: isar),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
