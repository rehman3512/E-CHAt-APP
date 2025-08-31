import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id, senderId, text;
  final String? imageUrl, audioUrl, docUrl, videoUrl;
  final Timestamp createdAt;
  final String type; // text, image, audio, video, file
  final String status; // sent, delivered, read

  MessageModel({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.imageUrl,
    this.audioUrl,
    this.docUrl,
    this.videoUrl,
    this.type = 'text',
    this.status = 'sent',
  });

  factory MessageModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};
    return MessageModel(
      id: d.id,
      senderId: m['senderId'] ?? '',
      text: m['text'] ?? '',
      imageUrl: m['imageUrl'],
      audioUrl: m['audioUrl'],
      docUrl: m['docUrl'],
      videoUrl: m['videoUrl'],
      type: m['type'] ?? 'text',
      status: m['status'] ?? 'sent',
      createdAt: m['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'text': text,
    'imageUrl': imageUrl,
    'audioUrl': audioUrl,
    'docUrl': docUrl,
    'videoUrl': videoUrl,
    'type': type,
    'status': status,
    'createdAt': createdAt,
  };
}


