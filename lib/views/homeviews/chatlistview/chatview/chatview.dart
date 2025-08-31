import 'package:chattingapp/data/models/messagemodel.dart';
import 'package:chattingapp/widgets/chatinput.dart';
import 'package:chattingapp/widgets/messagebubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chattingapp/controller/chatcontroller.dart';

import 'chatinfo/chatinfo.dart';


class ChatView extends StatelessWidget {
  final String chatId, peerId, peerName, peerPhone;
  ChatView({
    super.key,
    required this.chatId,
    required this.peerId,
    required this.peerName,
    required this.peerPhone,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ChatController(chatId, peerId), tag: chatId);
    final me = FirebaseAuth.instance.currentUser!.uid;
    final tc = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Get.to(() => ChatInfoScreen(
              peerId: peerId,
              peerName: peerName,
              peerPhone: peerPhone,
              peerPhoto: "", // yaha photo ka url dena agar hai
              chatId: chatId,
            ));
          },
          child: Row(
            children: [
              const CircleAvatar(child: Icon(Icons.person)),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(peerName, style: const TextStyle(fontSize: 16)),
                  Text(peerPhone, style: const TextStyle(fontSize: 12)),
                ],
              )
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
          ),
        ],
      ),
    );
  }
}
