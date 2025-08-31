import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupChatInfoScreen extends StatelessWidget {
  final String chatId, groupName, groupPhoto;

  const GroupChatInfoScreen({
    super.key,
    required this.chatId,
    required this.groupName,
    required this.groupPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Group Info")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundImage: groupPhoto.isNotEmpty ? NetworkImage(groupPhoto) : null,
              child: groupPhoto.isEmpty ? const Icon(Icons.group, size: 40) : null,
            ),
            const SizedBox(height: 10),
            Text(groupName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const Divider(height: 30),

            // Members List
            ListTile(title: const Text("Participants")),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("groups").doc(chatId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final data = snapshot.data!.data() as Map<String, dynamic>;
                final members = List<String>.from(data["members"] ?? []);
                if (members.isEmpty) return const Text("No Members");

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: members.length,
                  itemBuilder: (_, i) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection("users").doc(members[i]).get(),
                      builder: (context, userSnap) {
                        if (!userSnap.hasData) return const SizedBox();
                        final u = userSnap.data!.data() as Map<String, dynamic>;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: u["photo"] != null ? NetworkImage(u["photo"]) : null,
                            child: u["photo"] == null ? const Icon(Icons.person) : null,
                          ),
                          title: Text(u["name"] ?? "User"),
                          subtitle: Text(u["phone"] ?? ""),
                        );
                      },
                    );
                  },
                );
              },
            ),

            const Divider(height: 30),

            // Media & Docs Section
            ListTile(title: const Text("Media, Docs & Links")),
            SizedBox(
              height: 120,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("groups")
                    .doc(chatId)
                    .collection("messages")
                    .where("type", whereIn: ["image", "doc"])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) return const Center(child: Text("No Media Found"));
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: docs.length,
                    itemBuilder: (_, i) {
                      final data = docs[i].data() as Map<String, dynamic>;
                      if (data["type"] == "image") {
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: Image.network(data["url"], width: 100, fit: BoxFit.cover),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              const Icon(Icons.insert_drive_file, size: 40),
                              Text(data["fileName"] ?? "Doc"),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
