import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // Existing: sendCode, verifyCode (keep as-is)
  Future<void> sendCode(String phone, void Function(String) onCodeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (cred) async {
        await _auth.signInWithCredential(cred);
      },
      verificationFailed: (e) => throw e,
      codeSent: (id, _) => onCodeSent(id),
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<UserCredential> verifyCode(String verificationId, String smsCode) async {
    final cred = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth.signInWithCredential(cred);
  }

  // Save profile (used at initial setup)
  Future<void> saveProfile({required String name, File? photo}) async {
    final uid = _auth.currentUser!.uid;
    String photoUrl = '';
    if (photo != null) {
      final ref = _storage.ref('users/$uid/profile.jpg');
      await ref.putFile(photo);
      photoUrl = await ref.getDownloadURL();
    }

    await _db.collection('users').doc(uid).set({
      'name': name,
      'phone': _auth.currentUser!.phoneNumber,
      'photoUrl': photoUrl,
      'online': true,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ---------------------------
  // New / Useful helpers below
  // ---------------------------

  // Realtime user doc stream
  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfileStream(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }

  // One-time fetch
  Future<Map<String, dynamic>?> getProfileOnce(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  // Update profile fields. If photo provided, upload to storage and replace photoUrl.
  Future<void> updateProfile({
    required String uid,
    String? name,
    String? phone,
    File? photo,
    String? gender,
    String? birthday,
    String? email,
  }) async {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (gender != null) data['gender'] = gender;
    if (birthday != null) data['birthday'] = birthday;
    if (email != null) data['email'] = email;

    if (photo != null) {
      final ref = _storage.ref('users/$uid/profile.jpg');
      await ref.putFile(photo);
      final photoUrl = await ref.getDownloadURL();
      data['photoUrl'] = photoUrl;
    }

    if (data.isNotEmpty) {
      await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
    }
  }

  // Optional: delete profile image from storage
  Future<void> deleteProfileImage(String uid) async {
    final ref = _storage.ref('users/$uid/profile.jpg');
    try {
      await ref.delete();
      await _db.collection('users').doc(uid).update({'photoUrl': ''});
    } catch (e) {
      // ignore if not found
    }
  }
}
