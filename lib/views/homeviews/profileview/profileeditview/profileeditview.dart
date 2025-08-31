import 'package:chattingapp/controller/profilecontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditView extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final genderCtrl = TextEditingController();
  final birthdayCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Fill existing values
    nameCtrl.text = controller.name.value;
    phoneCtrl.text = controller.phone.value;
    emailCtrl.text = controller.email.value;
    genderCtrl.text = controller.gender.value;
    birthdayCtrl.text = controller.birthday.value;

    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Obx(() => GestureDetector(
              onTap: () => controller.pickImage(),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: controller.profileImage.value != null
                    ? FileImage(controller.profileImage.value!)
                    : (controller.profileImageUrl.value.isNotEmpty
                    ? NetworkImage(controller.profileImageUrl.value)
                    : AssetImage("assets/user.png")) as ImageProvider,
              ),
            )),
            SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: genderCtrl,
              decoration: InputDecoration(labelText: "Gender"),
            ),
            TextField(
              controller: birthdayCtrl,
              decoration: InputDecoration(labelText: "Birthday"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.updateProfile(
                  newName: nameCtrl.text,
                  newPhone: phoneCtrl.text,
                  newEmail: emailCtrl.text,
                  newGender: genderCtrl.text,
                  newBirthday: birthdayCtrl.text,
                );
              },
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}

//design
// import 'package:chattingapp/controller/profilecontroller.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ProfileEditView extends StatelessWidget {
//   final ProfileController controller = Get.find<ProfileController>();
//
//   final nameCtrl = TextEditingController();
//   final phoneCtrl = TextEditingController();
//   final emailCtrl = TextEditingController();
//   final genderCtrl = TextEditingController();
//   final birthdayCtrl = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     // Fill existing values
//     nameCtrl.text = controller.name.value;
//     phoneCtrl.text = controller.phone.value;
//     emailCtrl.text = controller.email.value;
//     genderCtrl.text = controller.gender.value;
//     birthdayCtrl.text = controller.birthday.value;
//
//     return Scaffold(
//       appBar: AppBar(title: Text("Edit Profile")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: ListView(
//           children: [
//             Obx(() => GestureDetector(
//               onTap: () => controller.pickImage(),
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage: controller.profileImage.value != null
//                     ? FileImage(controller.profileImage.value!)
//                     : (controller.profileImageUrl.value.isNotEmpty
//                     ? NetworkImage(controller.profileImageUrl.value)
//                     : AssetImage("assets/user.png")) as ImageProvider,
//               ),
//             )),
//             SizedBox(height: 20),
//             TextField(
//               controller: nameCtrl,
//               decoration: InputDecoration(labelText: "Name"),
//             ),
//             TextField(
//               controller: phoneCtrl,
//               decoration: InputDecoration(labelText: "Phone"),
//             ),
//             TextField(
//               controller: emailCtrl,
//               decoration: InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: genderCtrl,
//               decoration: InputDecoration(labelText: "Gender"),
//             ),
//             TextField(
//               controller: birthdayCtrl,
//               decoration: InputDecoration(labelText: "Birthday"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 controller.updateProfile(
//                   newName: nameCtrl.text,
//                   newPhone: phoneCtrl.text,
//                   newEmail: emailCtrl.text,
//                   newGender: genderCtrl.text,
//                   newBirthday: birthdayCtrl.text,
//                 );
//               },
//               child: Text("Save Changes"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }