import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/folder_model.dart';
import '../models/group_model.dart';
import 'chat_view.dart';

class HomeView extends StatefulWidget {
  final Isar isar;
  final int? parentFolderId;

  const HomeView({super.key, required this.isar, this.parentFolderId});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<dynamic>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() {
    _itemsFuture = _fetchItems();
  }

  Future<List<dynamic>> _fetchItems() async {
    final folders = await widget.isar.folders
        .filter()
        .parentFolderIdEqualTo(widget.parentFolderId)
        .sortByName()
        .findAll();

    final groups = await widget.isar.groups
        .filter()
        .parentFolderIdEqualTo(widget.parentFolderId)
        .sortByName()
        .findAll();

    return [...folders, ...groups];
  }

  void _refresh() {
    setState(() => _loadItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home_title'.tr()),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'new_group') {
                _showCreateDialog(context, isFolder: false);
              } else if (value == 'new_folder') {
                _showCreateDialog(context, isFolder: true);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'new_group', child: Text('new_group'.tr())),
              PopupMenuItem(
                value: 'new_folder',
                child: Text('new_folder'.tr()),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final items = snapshot.data!;
          if (items.isEmpty)
            return const Center(child: Text('No hay elementos.'));

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isFolder = item is Folder;
              final icon = isFolder ? Icons.folder : Icons.chat;
              final name = item.name;

              return ListTile(
                leading: Icon(
                  icon,
                  color: isFolder ? Colors.amber : Colors.green,
                ),
                title: Text(name),
                onTap: () {
                  if (isFolder) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomeView(
                          isar: widget.isar,
                          parentFolderId: item.id,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChatView(isar: widget.isar, group: item as Group),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, {required bool isFolder}) {
    final TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isFolder ? tr('create_folder') : tr('create_group')),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: tr('enter_name')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              final now = DateTime.now();

              if (isFolder) {
                final folder = Folder()
                  ..name = name
                  ..parentFolderId = widget.parentFolderId
                  ..createdAt = now
                  ..updatedAt = now;
                await widget.isar.writeTxn(
                  () async => await widget.isar.folders.put(folder),
                );
              } else {
                final group = Group()
                  ..name = name
                  ..parentFolderId = widget.parentFolderId
                  ..createdAt = now
                  ..updatedAt = now;
                await widget.isar.writeTxn(
                  () async => await widget.isar.groups.put(group),
                );
              }

              Navigator.of(context).pop();
              _refresh();
            },
            child: Text(tr('create')),
          ),
        ],
      ),
    );
  }
}
