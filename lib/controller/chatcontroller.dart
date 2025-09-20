// import 'dart:io';
// import 'package:chattingapp/data/models/messagemodel.dart';
// import 'package:chattingapp/data/services/chatservice.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
//
// class ChatController extends GetxController {
//   final String chatId;
//   final String peerId;
//   ChatController(this.chatId, this.peerId);
//
//   final _chat = ChatService();
//
//   Stream<List<MessageModel>> streamMessages() => _chat.messages(chatId);
//
//   Future<void> sendText(String text) => _chat.sendText(chatId, text);
//   Future<void> sendImage(File f) => _chat.sendImage(chatId, f);
//   Future<void> sendAudio(File f) => _chat.sendAudio(chatId, f);
//   Future<void> sendDoc(File f) => _chat.sendDoc(chatId, f);
//
//   String get myId => FirebaseAuth.instance.currentUser!.uid;
// }


import 'dart:io';
import 'package:chattingapp/data/models/messagemodel.dart';
import 'package:chattingapp/data/services/chatservice.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController extends GetxController {
  final String chatId;
  final String peerId;
  ChatController(this.chatId, this.peerId);

  final _chat = ChatService();

  Stream<List<MessageModel>> streamMessages() {
    // Stream messages aur unka status update kare
    return _chat.messages(chatId).map((messages) {
      _updateDeliveredStatus(messages);
      return messages;
    });
  }

  Future<void> sendText(String text) async {
    await _chat.sendText(chatId, text);
    // "sent" status update automatically hoti hai
  }

  Future<void> sendImage(File f) async => _chat.sendImage(chatId, f);
  Future<void> sendAudio(File f) async => _chat.sendAudio(chatId, f);
  Future<void> sendDoc(File f) async => _chat.sendDoc(chatId, f);

  String get myId => FirebaseAuth.instance.currentUser!.uid;

  // --------------------------
  // 🔹 Status update logic
  // --------------------------
  void _updateDeliveredStatus(List<MessageModel> messages) async {
    final batch = FirebaseFirestore.instance.batch();
    final uid = myId;

    for (var msg in messages) {
      if (msg.senderId != uid && msg.status == 'sent') {
        final msgRef = FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc(msg.id);
        batch.update(msgRef, {'status': 'delivered'});
      }
    }

    if (batch != null) {
      await batch.commit();
    }
  }

  // Optional: read status update when user opens chat
  Future<void> markMessagesRead(List<MessageModel> messages) async {
    final batch = FirebaseFirestore.instance.batch();
    final uid = myId;

    for (var msg in messages) {
      if (msg.senderId != uid && msg.status != 'read') {
        final msgRef = FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .doc(msg.id);
        batch.update(msgRef, {'status': 'read'});
      }
    }

    if (batch != null) {
      await batch.commit();
    }
  }
}
