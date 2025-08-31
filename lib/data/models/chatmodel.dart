import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String id; // chatId
  final List<String> members;
  final String lastMessage;
  final Timestamp updatedAt;
  final String type; // direct | group
  final String name; // for group or friendName
  final String photoUrl; // for group or friend profile

  ChatModel({
    required this.id,
    required this.members,
    required this.lastMessage,
    required this.updatedAt,
    required this.type,
    required this.name,
    required this.photoUrl,
  });

  factory ChatModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};
    return ChatModel(
      id: d.id,
      members: List<String>.from(m['members'] ?? const []),
      lastMessage: m['lastMessage'] ?? '',
      updatedAt: m['updatedAt'] ?? Timestamp.now(),
      type: m['type'] ?? 'direct',
      name: m['name'] ?? '',
      photoUrl: m['photoUrl'] ?? '',
    );
  }
}