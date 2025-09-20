// import 'package:chattingapp/data/models/chatmodel.dart';
// import 'package:chattingapp/data/services/presenceservice.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// class HomeController extends GetxController {
//   final rxIndex = 0.obs;
//   final isSearching = false.obs;
//   final query = ''.obs;
//
//   final isDarkMode = false.obs; // wired to ThemeController externally
//   final isMuted = false.obs;
//   final isLockEnabled = false.obs;
//   final selectedLanguage = 'en'.obs;
//
//   final uid = FirebaseAuth.instance.currentUser!.uid;
//
//   final chatsList = <ChatModel>[].obs;
//
//   Stream<List<ChatModel>> get _chatsStream => FirebaseFirestore.instance
//       .collection('chats')
//       .where('members', arrayContains: uid)
//       .orderBy('updatedAt', descending: true)
//       .snapshots()
//       .map((s) => s.docs.map((e) => ChatModel.fromDoc(e)).toList());
//
//   @override
//   void onInit() {
//     super.onInit();
//     _bindPresence();
//     _bindChats();
//   }
//
//   void _bindPresence() {
//     final presence = PresenceService();
//     presence.setOnline(true);
//     ever(rxIndex, (_) => presence.setOnline(true));
//   }
//
//   void _bindChats() {
//     _chatsStream.listen((list) => chatsList.assignAll(list));
//   }
//
//   // UI triggers
//   void openSearch() => isSearching.value = true;
//   void closeSearch() => isSearching.value = false;
//
//   // Mock add friend by phone/name -> ensures direct chat exists
//   Future<void> addFriendWithName(String phone, String name) async {
//     final db = FirebaseFirestore.instance;
//     final me = uid;
//     // find user by phone
//     final u = await db.collection('users').where('phone', isEqualTo: phone).limit(1).get();
//     if (u.docs.isEmpty) return;
//     final otherId = u.docs.first.id;
//
//     // direct chat id (sorted join for stable id)
//     final chatId = [me, otherId]..sort();
//     final id = chatId.join('_');
//     final ref = db.collection('chats').doc(id);
//     await ref.set({
//       'members': [me, otherId],
//       'type': 'direct',
//       'name': name, // for list subtitle
//       'updatedAt': FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));
//   }
//
//   // Settings toggles exposed for UI (no visual change)
//   void toggleDarkMode() {
//     isDarkMode.value = !isDarkMode.value;
//     // Theme change is handled by ThemeController externally in binding
//   }
//   void toggleMute() => isMuted.value = !isMuted.value;
//   void toggleLock(bool v) => isLockEnabled.value = v;
//   void changeLanguage(String v) => selectedLanguage.value = v;
//
//   Future<void> createGroup({
//     required String groupName,
//     String? bio,
//     String? imageUrl,
//     required List<String> members,
//   }) async {
//     final db = FirebaseFirestore.instance;
//     final me = uid;
//
//     final ref = db.collection('chats').doc();
//     await ref.set({
//       'id': ref.id,
//       'members': [me, ...members],
//       'type': 'group',
//       'name': groupName,
//       'bio': bio ?? '',
//       'image': imageUrl ?? '',
//       'updatedAt': FieldValue.serverTimestamp(),
//       'createdBy': me,
//     });
//   }
//
// }



import 'package:chattingapp/data/models/chatmodel.dart';
import 'package:chattingapp/data/services/presenceservice.dart';
import 'package:chattingapp/routes/approutes.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  final rxIndex = 0.obs;
  final isSearching = false.obs;
  final query = ''.obs;

  final isDarkMode = false.obs;
  final isMuted = false.obs;
  final isLockEnabled = false.obs;
  final selectedLanguage = 'en'.obs;

  String? uid; // <-- made nullable (safe)

  final chatsList = <ChatModel>[].obs;

  Stream<List<ChatModel>>? _chatsStream;

  @override
  void onInit() {
    super.onInit();
    _initUser(); // check if logged in
  }

  void _initUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // not logged in yet
    uid = user.uid;

    _chatsStream = FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((e) => ChatModel.fromDoc(e)).toList());

    _bindPresence();
    _bindChats();
  }

  void _bindPresence() {
    if (uid == null) return; // only if logged in
    final presence = PresenceService();
    presence.setOnline(true);
    ever(rxIndex, (_) => presence.setOnline(true));
  }

  void _bindChats() {
    if (_chatsStream == null) return;
    _chatsStream!.listen((list) => chatsList.assignAll(list));
  }

  // UI triggers
  void openSearch() => isSearching.value = true;
  void closeSearch() => isSearching.value = false;

  // Future<void> addFriendWithName(String phone, String name) async {
  //   // 1️⃣ Ensure current user is logged in
  //   final me = uid;
  //   if (me == null) {
  //     print("Current user not logged in");
  //     Get.snackbar("Error", "Please login first");
  //     return;
  //   }
  //
  //   final db = FirebaseFirestore.instance;
  //
  //   try {
  //     // 2️⃣ Normalize phone number (optional, ensure same format)
  //     final normalizedPhone = phone.trim();
  //
  //     // 3️⃣ Check if the friend already exists
  //     final userQuery = await db
  //         .collection('users')
  //         .where('phone', isEqualTo: normalizedPhone)
  //         .limit(1)
  //         .get();
  //
  //     String otherId;
  //
  //     if (userQuery.docs.isEmpty) {
  //       // 4️⃣ Create user if not exists
  //       final newUserRef = db.collection('users').doc();
  //       await newUserRef.set({
  //         'id': newUserRef.id,
  //         'phone': normalizedPhone,
  //         'name': name,
  //         'createdAt': FieldValue.serverTimestamp(),
  //       });
  //       otherId = newUserRef.id;
  //       print("New user created with ID: $otherId");
  //     } else {
  //       otherId = userQuery.docs.first.id;
  //       print("Existing user found with ID: $otherId");
  //     }
  //
  //     // 5️⃣ Create unique chatId (sorted)
  //     final chatId = [me, otherId]..sort();
  //     final id = chatId.join('_');
  //     final chatRef = db.collection('chats').doc(id);
  //
  //     final existingChat = await chatRef.get();
  //
  //     if (existingChat.exists) {
  //       // 6️⃣ Chat already exists, update timestamp
  //       await chatRef.update({'updatedAt': FieldValue.serverTimestamp()});
  //       print("Chat already exists. Timestamp updated.");
  //     } else {
  //       // 7️⃣ Create new direct chat
  //       await chatRef.set({
  //         'id': id,
  //         'members': [me, otherId],
  //         'type': 'direct',
  //         'name': name,
  //         'updatedAt': FieldValue.serverTimestamp(),
  //       });
  //       print("New chat created with ID: $id");
  //     }
  //
  //     Get.snackbar("Success", "Friend added successfully");
  //
  //   } catch (e) {
  //     print("Failed to add friend: $e");
  //     Get.snackbar("Error", "Failed to add friend");
  //   }
  // }

  Future<void> addFriendWithName(String phone, String name) async {
    final me = uid;
    if (me == null || me.isEmpty) {
      Get.snackbar("Error", "Please login first");
      return;
    }

    final db = FirebaseFirestore.instance;
    try {
      final normalizedPhone = phone.replaceAll(RegExp(r'\s+'), '');

      // Check if user exists
      final userQuery = await db
          .collection('users')
          .where('phone', isEqualTo: normalizedPhone)
          .limit(1)
          .get();

      String otherId;
      if (userQuery.docs.isEmpty) {
        final newUserRef = db.collection('users').doc();
        await newUserRef.set({
          'id': newUserRef.id,
          'phone': normalizedPhone,
          'name': name,
          'createdAt': FieldValue.serverTimestamp(),
        });
        otherId = newUserRef.id;
        print("New user created: $otherId");
      } else {
        otherId = userQuery.docs.first.id;
        print("Existing user: $otherId");
      }

      // Create unique chat
      final chatId = [me, otherId]..sort();
      final id = chatId.join('_');
      final chatRef = db.collection('chats').doc(id);

      final existingChat = await chatRef.get();

      if (!existingChat.exists) {
        await chatRef.set({
          'id': id,
          'members': [me, otherId],
          'type': 'direct',
          'name': name,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        print("Chat created: $id");
      } else {
        await chatRef.update({'updatedAt': FieldValue.serverTimestamp()});
        print("Chat updated: $id");
      }

      chatsList.refresh();

      if (Get.isSnackbarOpen) Get.closeAllSnackbars();
      Get.snackbar("Success", "$name added successfully");

      if (Get.isBottomSheetOpen == true) Get.back();

    } catch (e) {
      print("Failed to add friend: $e");
      Get.snackbar("Error", "Failed to add friend");
    }
  }



  void toggleDarkMode() => isDarkMode.value = !isDarkMode.value;
  void toggleMute() => isMuted.value = !isMuted.value;
  void toggleLock(bool v) => isLockEnabled.value = v;
  void changeLanguage(String v) => selectedLanguage.value = v;

  Future<void> createGroup({
    required String groupName,
    String? bio,
    String? imageUrl,
    required List<String> members,
  }) async {
    if (uid == null) return;
    final db = FirebaseFirestore.instance;
    final me = uid!;

    final ref = db.collection('chats').doc();
    await ref.set({
      'id': ref.id,
      'members': [me, ...members],
      'type': 'group',
      'name': groupName,
      'bio': bio ?? '',
      'image': imageUrl ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
      'createdBy': me,
    });
  }


  void logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Firebase logout
      Get.offAndToNamed(AppRoutes.Login ); // Navigate to LoginScreen and remove previous routes
    } catch (e) {
      print("Error logging out: $e");
      Get.snackbar("Error", "Failed to logout"); // Optional: show error message
    }
  }

}
