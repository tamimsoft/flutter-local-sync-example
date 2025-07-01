// import 'package:flutter/material.dart';
// class GenericAlertDialog {
//   static void show({
//     required String title,
//     required String message,
//     String confirmText = 'OK',
//     String cancelText = 'Cancel',
//     VoidCallback? onConfirm,
//     VoidCallback? onCancel,
//     bool isCancelable = true,
//   }) {
//     Get.dialog(AlertDialog(
//       title: Text(title),
//       content: Text(message),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Get.back();
//             if (onCancel != null) {
//               onCancel();
//             }
//           },
//           child: Text(cancelText),
//         ),
//         TextButton(
//           style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
//           onPressed: () {
//             Get.back();
//             if (onConfirm != null) {
//               onConfirm();
//             }
//           },
//           child: Text(confirmText),
//         ),
//       ],
//     ));
//   }
// }
