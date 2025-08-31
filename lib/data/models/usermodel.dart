import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String phone;
  final String name;
  final String photoUrl;
  final bool online;
  final Timestamp? lastSeen;

  UserModel({
    required this.id,
    required this.phone,
    required this.name,
    required this.photoUrl,
    required this.online,
    required this.lastSeen,
  });

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};
    return UserModel(
      id: d.id,
      phone: m['phone'] ?? '',
      name: m['name'] ?? '',
      photoUrl: m['photoUrl'] ?? '',
      online: m['online'] ?? false,
      lastSeen: m['lastSeen'],
    );
  }

  Map<String, dynamic> toMap() => {
    'phone': phone,
    'name': name,
    'photoUrl': photoUrl,
    'online': online,
    'lastSeen': lastSeen,
  };
}
