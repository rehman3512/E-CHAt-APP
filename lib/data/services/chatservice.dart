import 'dart:io';
import 'package:chattingapp/data/models/messagemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


class ChatService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;

  Stream<List<MessageModel>> messages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((e) => MessageModel.fromDoc(e)).toList());
  }

  Future<void> sendText(String chatId, String text) async {
    if (text.trim().isEmpty) return;
    final uid = _auth.currentUser!.uid;
    final ref = _db.collection('chats').doc(chatId);
    final msgRef = ref.collection('messages').doc();

    await msgRef.set({
      'senderId': uid,
      'text': text.trim(),
      'type': 'text',
      'status': 'sent',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await ref.update({
      'lastMessage': text.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> _upload(String path, File f) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final r = _storage.ref('$path/$id');
    await r.putFile(f);
    return r.getDownloadURL();
  }

  Future<void> sendImage(String chatId, File file) async {
    final url = await _upload('chat_images/$chatId', file);
    await _sendMedia(chatId, url, 'imageUrl', 'image');
  }

  Future<void> sendAudio(String chatId, File file) async {
    final url = await _upload('chat_audio/$chatId', file);
    await _sendMedia(chatId, url, 'audioUrl', 'audio');
  }

  Future<void> sendDoc(String chatId, File file) async {
    final url = await _upload('chat_docs/$chatId', file);
    await _sendMedia(chatId, url, 'docUrl', 'file');
  }

  Future<void> _sendMedia(String chatId, String url, String key, String type) async {
    final uid = _auth.currentUser!.uid;
    final ref = _db.collection('chats').doc(chatId);
    await ref.collection('messages').add({
      'senderId': uid,
      'text': '',
      key: url,
      'type': type,
      'status': 'sent',
      'createdAt': FieldValue.serverTimestamp(),
    });
    await ref.update({
      'lastMessage': type,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
