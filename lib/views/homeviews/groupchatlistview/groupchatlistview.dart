import 'package:chattingapp/views/homeviews/chatlistview/chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupListScreen extends StatelessWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Groups"),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.group_add),
      //       onPressed: () {
      //         // yahan group create ka screen open karwana hoga
      //         // tumhari existing group create logic yahan lagao
      //       },
      //     )
      //   ],
      // ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .where("members", arrayContains: me)
            .where("type", isEqualTo: "group")
            .orderBy("updatedAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No groups yet"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final group = docs[index].data();
              final chatId = docs[index].id;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: group["photoUrl"] != null && group["photoUrl"].toString().isNotEmpty
                      ? NetworkImage(group["photoUrl"])
                      : null,
                  backgroundColor: Colors.blueAccent,
                  child: group["photoUrl"] == null || group["photoUrl"].toString().isEmpty
                      ? const Icon(Icons.group, color: Colors.white)
                      : null,
                ),
                title: Text(group["name"] ?? "Unnamed Group"),
                subtitle: Text(group["lastMessage"] ?? ""),
                trailing: Text(
                  _formatTime(group["updatedAt"]),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () {
                  Get.to(() => ChatView(
                    chatId: chatId,
                    peerId: "", // group me specific peerId ni hoga
                    peerName: group["name"] ?? "Group",
                    peerPhone: "", // group me phone ni hota
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(Timestamp? ts) {
    if (ts == null) return "";
    final dt = ts.toDate();
    final now = DateTime.now();
    if (now.difference(dt).inDays == 0) {
      return "${dt.hour}:${dt.minute.toString().padLeft(2, "0")}";
    } else {
      return "${dt.day}/${dt.month}";
    }
  }
}
