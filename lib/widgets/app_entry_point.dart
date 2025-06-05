import 'package:flutter/material.dart';
import 'stateless_widget.dart';
import 'package:isar/isar.dart';

class AppEntryPoint extends StatelessWidget {
  final Isar isar;
  const AppEntryPoint({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MyApp(isar: isar);
  }
}
