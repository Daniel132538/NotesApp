import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/message_model.dart';
import '../models/group_model.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatView extends StatefulWidget {
  final Isar isar;
  final Group group;

  const ChatView({super.key, required this.isar, required this.group});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();

  late final Stream<List<Message>> _messageStream;

  @override
  void initState() {
    super.initState();
    _messageStream = widget.isar.messages
        .filter()
        .groupIdEqualTo(widget.group.id)
        .sortByCreatedAt()
        .watch(fireImmediately: true);
  }

  void _sendMessage() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    final message = Message()
      ..content = content
      ..groupId = widget.group.id
      ..createdAt = DateTime.now();

    await widget.isar.writeTxn(() async {
      await widget.isar.messages.put(message);
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _messageStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: false,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return ListTile(
                      title: MarkdownBody(
                        data: msg.content,
                        styleSheet: MarkdownStyleSheet.fromTheme(
                          Theme.of(context),
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(msg.createdAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5, // o null para ilimitado
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: tr('write_message'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
