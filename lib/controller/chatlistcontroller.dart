// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:chattingapp/data/models/chatmodel.dart';
// import 'package:chattingapp/data/models/usermodel.dart';
//
// class ChatListController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   final RxList<ChatModel> chats = <ChatModel>[].obs;
//   final RxMap<String, UserModel> userCache = <String, UserModel>{}.obs;
//   final RxString loadingStatus = 'loading'.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadChats();
//   }
//
//   void loadChats() {
//     final me = _auth.currentUser!.uid;
//
//     _firestore
//         .collection("chats")
//         .where("members", arrayContains: me)
//         .orderBy("updatedAt", descending: true)
//         .snapshots()
//         .listen((querySnapshot) async {
//       if (querySnapshot.docs.isEmpty) {
//         loadingStatus.value = 'empty';
//         return;
//       }
//
//       // Convert documents to ChatModel
//       final newChats = querySnapshot.docs
//           .map((doc) => ChatModel.fromDoc(doc))
//           .toList();
//
//       chats.assignAll(newChats);
//
//       // Fetch user data for all direct chats
//       await _fetchUsersForChats(newChats);
//
//       loadingStatus.value = 'loaded';
//     }, onError: (error) {
//       loadingStatus.value = 'error';
//     });
//   }
//
//   Future<void> _fetchUsersForChats(List<ChatModel> chats) async {
//     final me = _auth.currentUser!.uid;
//
//     // Get all peer IDs from direct chats
//     final peerIds = chats
//         .where((chat) => chat.type == 'direct')
//         .map((chat) => chat.members.firstWhere((id) => id != me, orElse: () => ''))
//         .where((id) => id.isNotEmpty && !userCache.containsKey(id))
//         .toSet()
//         .toList();
//
//     if (peerIds.isEmpty) return;
//
//     // Fetch all users at once
//     final usersSnapshot = await _firestore
//         .collection('users')
//         .where(FieldPath.documentId, whereIn: peerIds)
//         .get();
//
//     for (var doc in usersSnapshot.docs) {
//       userCache[doc.id] = UserModel.fromDoc(doc);
//     }
//   }
//
//   UserModel? getPeerUser(String peerId) {
//     return userCache[peerId];
//   }
//
//   String getPeerId(ChatModel chat) {
//     if (chat.type == 'direct') {
//       final me = _auth.currentUser!.uid;
//       return chat.members.firstWhere((id) => id != me, orElse: () => '');
//     }
//     return '';
//   }
//
//   // Chat delete karne ka function
//   Future<void> deleteChat(String chatId) async {
//     await _firestore.collection('chats').doc(chatId).delete();
//   }
//
//   // Chat mute karne ka function
//   Future<void> muteChat(String chatId) async {
//     await _firestore.collection('chats').doc(chatId).update({
//       'muted': true,
//     });
//   }
// }


import 'dart:async'; // Add this import for StreamSubscription
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chattingapp/data/models/chatmodel.dart'; // Make sure this path is correct
import 'package:chattingapp/data/models/usermodel.dart';

class ChatListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<ChatModel> chats = <ChatModel>[].obs;
  final RxMap<String, UserModel> userCache = <String, UserModel>{}.obs;
  final RxString loadingStatus = 'loading'.obs;
  StreamSubscription? _chatsSubscription;

  @override
  void onInit() {
    super.onInit();
    _setupAuthListener();
  }

  @override
  void onClose() {
    _chatsSubscription?.cancel();
    super.onClose();
  }

  void _setupAuthListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is signed in
        loadChats();
      } else {
        // User is signed out
        chats.clear();
        userCache.clear();
        loadingStatus.value = 'empty';
      }
    });
  }

  void loadChats() {
    final me = _auth.currentUser?.uid;
    if (me == null) {
      loadingStatus.value = 'error';
      return;
    }

    // Cancel any existing subscription
    _chatsSubscription?.cancel();

    _chatsSubscription = _firestore
        .collection("chats")
        .where("members", arrayContains: me)
        .orderBy("updatedAt", descending: true)
        .snapshots()
        .listen((querySnapshot) async {
      if (querySnapshot.docs.isEmpty) {
        loadingStatus.value = 'empty';
        return;
      }

      // Convert documents to ChatModel
      final newChats = querySnapshot.docs
          .map((doc) => ChatModel.fromDoc(doc))
          .toList();

      // Update chats list
      chats.assignAll(newChats);

      // Fetch user data for all direct chats
      await _fetchUsersForChats(newChats);

      loadingStatus.value = 'loaded';
    }, onError: (error) {
      loadingStatus.value = 'error';
      print("Error loading chats: $error");
    });
  }

  Future<void> _fetchUsersForChats(List<ChatModel> chats) async {
    final me = _auth.currentUser?.uid;
    if (me == null) return;

    // Get all peer IDs from direct chats
    final peerIds = chats
        .where((chat) => chat.type == 'direct')
        .map((chat) => chat.members.firstWhere((id) => id != me, orElse: () => ''))
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    if (peerIds.isEmpty) return;

    // Remove any users that are no longer in chats
    userCache.removeWhere((key, value) => !peerIds.contains(key));

    // Fetch only users that are not in cache
    final usersToFetch = peerIds.where((id) => !userCache.containsKey(id)).toList();

    if (usersToFetch.isEmpty) return;

    try {
      final usersSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: usersToFetch)
          .get();

      for (var doc in usersSnapshot.docs) {
        userCache[doc.id] = UserModel.fromDoc(doc);
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  UserModel? getPeerUser(String peerId) {
    return userCache[peerId];
  }

  String getPeerId(ChatModel chat) {
    if (chat.type == 'direct') {
      final me = _auth.currentUser?.uid;
      if (me == null) return '';
      return chat.members.firstWhere((id) => id != me, orElse: () => '');
    }
    return '';
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await _firestore.collection('chats').doc(chatId).delete();
    } catch (e) {
      print("Error deleting chat: $e");
    }
  }

  Future<void> muteChat(String chatId) async {
    try {
      await _firestore.collection('chats').doc(chatId).update({
        'muted': true,
      });
    } catch (e) {
      print("Error muting chat: $e");
    }
  }
}