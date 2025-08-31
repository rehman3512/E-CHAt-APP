import 'dart:io';
import 'package:chattingapp/data/models/messagemodel.dart';
import 'package:chattingapp/data/services/chatservice.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChatController extends GetxController {
  final String chatId;
  final String peerId;
  ChatController(this.chatId, this.peerId);

  final _chat = ChatService();

  Stream<List<MessageModel>> streamMessages() => _chat.messages(chatId);

  Future<void> sendText(String text) => _chat.sendText(chatId, text);
  Future<void> sendImage(File f) => _chat.sendImage(chatId, f);
  Future<void> sendAudio(File f) => _chat.sendAudio(chatId, f);
  Future<void> sendDoc(File f) => _chat.sendDoc(chatId, f);

  String get myId => FirebaseAuth.instance.currentUser!.uid;
}
