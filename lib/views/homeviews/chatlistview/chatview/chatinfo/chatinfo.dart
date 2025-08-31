// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class ChatInfoScreen extends StatelessWidget {
//   final String peerId, peerName, peerPhone, peerPhoto, chatId;
//
//   const ChatInfoScreen({
//     super.key,
//     required this.peerId,
//     required this.peerName,
//     required this.peerPhone,
//     required this.peerPhoto,
//     required this.chatId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Chat Info")),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             CircleAvatar(
//               radius: 40,
//               backgroundImage: peerPhoto.isNotEmpty ? NetworkImage(peerPhoto) : null,
//               child: peerPhoto.isEmpty ? const Icon(Icons.person, size: 40) : null,
//             ),
//             const SizedBox(height: 10),
//             Text(peerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text(peerPhone, style: const TextStyle(color: Colors.grey)),
//
//             const Divider(height: 30),
//
//             // Media & Docs Section
//             ListTile(
//               title: const Text("Media, Docs & Links"),
//             ),
//             SizedBox(
//               height: 120,
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("chats")
//                     .doc(chatId)
//                     .collection("messages")
//                     .where("type", whereIn: ["image", "doc"])
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//                   final docs = snapshot.data!.docs;
//                   if (docs.isEmpty) return const Center(child: Text("No Media Found"));
//                   return ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: docs.length,
//                     itemBuilder: (_, i) {
//                       final data = docs[i].data() as Map<String, dynamic>;
//                       if (data["type"] == "image") {
//                         return Padding(
//                           padding: const EdgeInsets.all(4),
//                           child: Image.network(data["url"], width: 100, fit: BoxFit.cover),
//                         );
//                       } else {
//                         return Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: Column(
//                             children: [
//                               const Icon(Icons.insert_drive_file, size: 40),
//                               Text(data["fileName"] ?? "Doc"),
//                             ],
//                           ),
//                         );
//                       }
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chattingapp/controller/chatcontroller.dart';

class ChatInfoScreen extends StatelessWidget {
  final String peerId, peerName, peerPhone, peerPhoto, chatId;

  const ChatInfoScreen({
    super.key,
    required this.peerId,
    required this.peerName,
    required this.peerPhone,
    required this.peerPhoto,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Info"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: peerPhoto.isNotEmpty
                        ? NetworkImage(peerPhoto)
                        : null,
                    child: peerPhoto.isEmpty
                        ? Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    peerName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    peerPhone,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.call, 'Call', () {}),
                      _buildActionButton(Icons.videocam, 'Video', () {}),
                      _buildActionButton(Icons.search, 'Search', () {}),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Media, Links and Docs Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Media, links, and docs",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("chats")
                          .doc(chatId)
                          .collection("messages")
                          .where("type", whereIn: ["image", "doc", "video"])
                          .orderBy("createdAt", descending: true)
                          .limit(10)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final docs = snapshot.data!.docs;
                        if (docs.isEmpty) {
                          return const Center(child: Text("No media found"));
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data = docs[index].data() as Map<String, dynamic>;
                            final type = data["type"];

                            if (type == "image") {
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: Image.network(
                                  data["imageUrl"],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 100,
                                height: 100,
                                color: Colors.grey[200],
                                child: const Icon(Icons.insert_drive_file, size: 40),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("View all"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Options Section
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildListTile(Icons.notifications, "Mute notifications", () {}),
                  _buildListTile(Icons.lock, "Encryption", () {}),
                  _buildListTile(Icons.visibility, "Disappearing messages", () {}),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Danger Zone
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildListTile(Icons.block, "Block $peerName", () {}, color: Colors.red),
                  _buildListTile(Icons.report, "Report $peerName", () {}, color: Colors.red),
                  _buildListTile(Icons.delete, "Delete chat", () {}, color: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.teal),
          onPressed: onPressed,
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
}