import 'dart:io';
import 'package:chattingapp/routes/approutes.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chattingapp/data/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  // reactive fields used by UI (no UI change)
  var name = "Guest User".obs;
  var phone = "".obs;
  var gender = "Male".obs;
  var birthday = "".obs;
  var email = "".obs;

  var profileImage = Rxn<File>();        // local picked image
  var profileImageUrl = "".obs;         // firestore URL

  // local image picker
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    if (uid.isNotEmpty) {
      _bindProfileStream();
    }
  }

  void _bindProfileStream() {
    _authService.getProfileStream(uid).listen((snapshot) {
      final data = snapshot.data() ?? {};
      name.value = data['name'] ?? name.value;
      phone.value = data['phone'] ?? phone.value;
      profileImageUrl.value = data['photoUrl'] ?? profileImageUrl.value;
      gender.value = data['gender'] ?? gender.value;
      birthday.value = data['birthday'] ?? birthday.value;
      email.value = data['email'] ?? email.value;
    });
  }

  // pick image from gallery (used by your existing UI)
  Future<void> pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage.value = File(picked.path);
    }
  }

  // Save initial profile (used by ProfileSetupView)
  Future<void> saveProfile(String newName) async {
    if (uid.isEmpty) return;
    try {
      await _authService.saveProfile(name: newName, photo: profileImage.value);
      // after save the Firestore stream will update values -> UI updates automatically
      Get.offAllNamed("/HomeView");
    } catch (e) {
      Get.snackbar("Error", "Failed to save profile: $e");
    }
  }

  // Update profile (used by ProfileEditView)
  Future<void> updateProfile({
    String? newName,
    String? newPhone,
    String? newGender,
    String? newBirthday,
    String? newEmail,
  }) async {
    if (uid.isEmpty) return;
    try {
      await _authService.updateProfile(
        uid: uid,
        name: newName,
        phone: newPhone,
        photo: profileImage.value,
        gender: newGender,
        birthday: newBirthday,
        email: newEmail,
      );
      // local state will update from stream; optionally show toast
      Get.back();
      Get.snackbar("Success", "Profile updated");
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile: $e");
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => AppRoutes.Login);
    } catch (e) {
      Get.snackbar("Error", "Logout failed: $e");
    }
  }

  // Convenience to fill controller fields (for edit screen)
  void fillFromCurrentState({
    String? n,
    String? p,
    String? g,
    String? b,
    String? e,
  }) {
    if (n != null) name.value = n;
    if (p != null) phone.value = p;
    if (g != null) gender.value = g;
    if (b != null) birthday.value = b;
    if (e != null) email.value = e;
  }

}
