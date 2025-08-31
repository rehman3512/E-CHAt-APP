import 'package:chattingapp/controller/profilecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profileeditview/profileeditview.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Get.to(() => ProfileEditView()),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() => Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: controller.profileImageUrl.value.isNotEmpty
                  ? NetworkImage(controller.profileImageUrl.value)
                  : AssetImage("assets/user.png") as ImageProvider,
            ),
            SizedBox(height: 20),
            Text(controller.name.value,
                style:
                TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(controller.phone.value),
            SizedBox(height: 5),
            Text(controller.email.value),
            SizedBox(height: 5),
            Text("Gender: ${controller.gender.value}"),
            SizedBox(height: 5),
            Text("Birthday: ${controller.birthday.value}"),
          ],
        )),
      ),
    );
  }
}



// design
// import 'package:chattingapp/controller/profilecontroller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'profileeditview/profileeditview.dart';
//
// class ProfileView extends StatelessWidget {
//   final ProfileController controller = Get.put(ProfileController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Profile"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () => Get.to(() => ProfileEditView()),
//           )
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Obx(() => Column(
//           children: [
//             CircleAvatar(
//               radius: 60,
//               backgroundImage: controller.profileImageUrl.value.isNotEmpty
//                   ? NetworkImage(controller.profileImageUrl.value)
//                   : AssetImage("assets/user.png") as ImageProvider,
//             ),
//             SizedBox(height: 20),
//             Text(controller.name.value,
//                 style:
//                 TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             SizedBox(height: 5),
//             Text(controller.phone.value),
//             SizedBox(height: 5),
//             Text(controller.email.value),
//             SizedBox(height: 5),
//             Text("Gender: ${controller.gender.value}"),
//             SizedBox(height: 5),
//             Text("Birthday: ${controller.birthday.value}"),
//           ],
//         )),
//       ),
//     );
//   }
// }