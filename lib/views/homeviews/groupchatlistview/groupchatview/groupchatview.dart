import 'package:chattingapp/controller/chatcontroller.dart';
import 'package:chattingapp/data/models/messagemodel.dart';
import 'package:chattingapp/widgets/chatinput.dart';
import 'package:chattingapp/widgets/messagebubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'groupinfo/groupinfo.dart';


class GroupChatView extends StatelessWidget {
  final String chatId, groupName, groupPhoto;
  GroupChatView({
    super.key,
    required this.chatId,
    required this.groupName,
    required this.groupPhoto,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ChatController(chatId, ""), tag: chatId);
    final me = FirebaseAuth.instance.currentUser!.uid;
    final tc = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Get.to(() => GroupChatInfoScreen(
              chatId: chatId,
              groupName: groupName,
              groupPhoto: groupPhoto,
            ));
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: groupPhoto.isNotEmpty ? NetworkImage(groupPhoto) : null,
                child: groupPhoto.isEmpty ? const Icon(Icons.group) : null,
              ),
              const SizedBox(width: 8),
              Text(groupName, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: ctrl.streamMessages(),
              builder: (c, s) {
                if (!s.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final list = s.data!;
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final m = list[i];
                    return MessageBubble(m: m, isMe: m.senderId == me);
                  },
                );
              },
            ),
          ),
          ChatInput(
            c: tc,
            onSend: () => ctrl.sendText(tc.text).then((_) => tc.clear()),
            onAttach: () => showAttachSheet(
              context,
              onCamera: () {},
              onGallery: () {},
              onLocation: () {},
              onDocument: () {},
              onContact: () {},
              onRecord: () {},
            ),
          )
        ],
      ),
    );
  }
}
