import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class HomeView extends StatelessWidget {
  final Isar isar;
  const HomeView({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: const Center(child: Text("Pantalla vacía")),
    );
  }
}
