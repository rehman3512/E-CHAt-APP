// import 'package:chattingapp/controller/chatlistcontroller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:chattingapp/views/homeviews/chatlistview/chatview/chatview.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// // Naya controller initialize karein
// final ChatListController chatListController = Get.put(ChatListController());
//
// class ChatListScreen extends StatelessWidget {
//   ChatListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         // Loading states handle karein
//         if (chatListController.loadingStatus.value == 'loading') {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (chatListController.loadingStatus.value == 'error') {
//           return const Center(child: Text("Error loading chats"));
//         }
//
//         if (chatListController.chats.isEmpty) {
//           return const Center(child: Text("No chats yet"));
//         }
//
//         return ListView.builder(
//           itemCount: chatListController.chats.length,
//           itemBuilder: (context, index) {
//             final chat = chatListController.chats[index];
//             final peerId = chatListController.getPeerId(chat);
//             final peer = chatListController.getPeerUser(peerId);
//
//             String title = chat.name;
//             String photoUrl = chat.photoUrl;
//             bool isOnline = false;
//
//             if (chat.type == 'direct' && peer != null) {
//               title = peer.name;
//               photoUrl = peer.photoUrl;
//               isOnline = peer.online;
//             }
//
//             return Dismissible(
//               key: Key(chat.id),
//               background: Container(
//                 color: Colors.red,
//                 alignment: Alignment.centerLeft,
//                 padding: const EdgeInsets.only(left: 20),
//                 child: const Icon(Icons.delete, color: Colors.white),
//               ),
//               secondaryBackground: Container(
//                 color: Colors.orange,
//                 alignment: Alignment.centerRight,
//                 padding: const EdgeInsets.only(right: 20),
//                 child: const Icon(Icons.notifications_off, color: Colors.white),
//               ),
//               onDismissed: (direction) async {
//                 if (direction == DismissDirection.startToEnd) {
//                   await chatListController.deleteChat(chat.id);
//                 } else {
//                   await chatListController.muteChat(chat.id);
//                 }
//               },
//               child: ListTile(
//                 leading: Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 24,
//                       backgroundImage:
//                       photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
//                       child: photoUrl.isEmpty ? const Icon(Icons.person) : null,
//                     ),
//                     if (isOnline)
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           width: 12,
//                           height: 12,
//                           decoration: BoxDecoration(
//                             color: Colors.green,
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white, width: 2),
//                           ),
//                         ),
//                       )
//                   ],
//                 ),
//                 title: Text(title),
//                 subtitle: Text(chat.lastMessage),
//                 trailing: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       _formatTime(chat.updatedAt),
//                       style: const TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                     const SizedBox(height: 4),
//                     StreamBuilder<QuerySnapshot>(
//                       stream: FirebaseFirestore.instance
//                           .collection('chats')
//                           .doc(chat.id)
//                           .collection('messages')
//                           .where('read', isEqualTo: false)
//                           .where('senderId', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
//                           .snapshots(),
//                       builder: (c, s) {
//                         if (!s.hasData || s.data!.docs.isEmpty) {
//                           return const SizedBox.shrink();
//                         }
//                         return Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: Colors.green,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             s.data!.docs.length.toString(),
//                             style: const TextStyle(color: Colors.white, fontSize: 12),
//                           ),
//                         );
//                       },
//                     )
//                   ],
//                 ),
//                 onTap: () {
//                   if (chat.type == 'direct' && peer != null) {
//                     Get.to(() => ChatView(
//                       chatId: chat.id,
//                       peerId: peer.id,
//                       peerName: peer.name,
//                       peerPhone: peer.phone,
//                     ));
//                   } else if (chat.type == 'group') {
//                     Get.to(() => ChatView(
//                       chatId: chat.id,
//                       peerId: '',
//                       peerName: chat.name,
//                       peerPhone: '',
//                     ));
//                   }
//                 },
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
//
//   String _formatTime(Timestamp ts) {
//     final dt = ts.toDate();
//     final now = DateTime.now();
//     if (now.difference(dt).inDays == 0) {
//       return "${dt.hour}:${dt.minute.toString().padLeft(2, "0")}";
//     } else {
//       return "${dt.day}/${dt.month}";
//     }
//   }
// }



import 'package:chattingapp/controller/chatlistcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chattingapp/views/homeviews/chatlistview/chatview/chatview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});
  final ChatListController chatListController = Get.put(ChatListController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => chatListController.loadChats(),
          ),
        ],
      ),
      body: Obx(() {
        // Loading states handle karein
        if (chatListController.loadingStatus.value == 'loading') {
          return const Center(child: CircularProgressIndicator());
        }

        if (chatListController.loadingStatus.value == 'error') {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Error loading chats"),
                ElevatedButton(
                  onPressed: () => chatListController.loadChats(),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        if (chatListController.chats.isEmpty) {
          return const Center(child: Text("No chats yet"));
        }

        return ListView.builder(
          itemCount: chatListController.chats.length,
          itemBuilder: (context, index) {
            final chat = chatListController.chats[index];
            final peerId = chatListController.getPeerId(chat);
            final peer = chatListController.getPeerUser(peerId);

            String title = chat.name;
            String photoUrl = chat.photoUrl;
            bool isOnline = false;

            if (chat.type == 'direct' && peer != null) {
              title = peer.name;
              photoUrl = peer.photoUrl;
              isOnline = peer.online;
            } else if (chat.type == 'direct' && peer == null) {
              // Show loading for users not yet fetched
              title = "Loading...";
            }

            return Dismissible(
              key: Key(chat.id),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.orange,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.notifications_off, color: Colors.white),
              ),
              onDismissed: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  await chatListController.deleteChat(chat.id);
                } else {
                  await chatListController.muteChat(chat.id);
                }
              },
              child: ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                      photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                      child: photoUrl.isEmpty ? const Icon(Icons.person) : null,
                    ),
                    if (isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      )
                  ],
                ),
                title: Text(title),
                subtitle: Text(chat.lastMessage.isNotEmpty ? chat.lastMessage : "No messages yet"),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTime(chat.updatedAt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chat.id)
                          .collection('messages')
                          .where('read', isEqualTo: false)
                          .where('senderId', isNotEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
                          .snapshots(),
                      builder: (c, s) {
                        if (!s.hasData || s.data!.docs.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            s.data!.docs.length.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        );
                      },
                    )
                  ],
                ),
                onTap: () {
                  if (chat.type == 'direct' && peer != null) {
                    Get.to(() => ChatView(
                      chatId: chat.id,
                      peerId: peer.id,
                      peerName: peer.name,
                      peerPhone: peer.phone,
                    ));
                  } else if (chat.type == 'group') {
                    Get.to(() => ChatView(
                      chatId: chat.id,
                      peerId: '',
                      peerName: chat.name,
                      peerPhone: '',
                    ));
                  }
                },
              ),
            );
          },
        );
      }),
    );
  }

  String _formatTime(Timestamp ts) {
    final dt = ts.toDate();
    final now = DateTime.now();
    if (now.difference(dt).inDays == 0) {
      return "${dt.hour}:${dt.minute.toString().padLeft(2, "0")}";
    } else {
      return "${dt.day}/${dt.month}";
    }
  }
}