import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chattingapp/constants/appcolors/appcolors.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String peerId, peerName, peerPhone;
  const ChatAppBar({super.key, required this.peerId, required this.peerName, required this.peerPhone});

  String _lastSeenText(Timestamp? ts, bool online) {
    if (online) return "Online";
    if (ts == null) return "last seen recently";
    final dt = ts.toDate();
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return "last seen $h:$m";
  }

  @override
  Widget build(BuildContext context) {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(peerId).snapshots();
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: const BackButton(color: AppColors.textPrimary),
      titleSpacing: 0,
      title: StreamBuilder(
        stream: userDoc,
        builder: (c, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> s) {
          final d = s.data?.data();
          final online = (d?['online'] ?? false) as bool;
          final lastSeen = d?['lastSeen'] as Timestamp?;
          return Row(children: [
            const CircleAvatar(radius: 18, backgroundImage: AssetImage("assets/splashLogo.png")),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(peerName, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontSize: 16)),
              Text(_lastSeenText(lastSeen, online), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ]),
          ]);
        },
      ),
      actions: const [
        Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Icon(Icons.call)),
        Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Icon(Icons.videocam)),
        Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Icon(Icons.more_vert)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}