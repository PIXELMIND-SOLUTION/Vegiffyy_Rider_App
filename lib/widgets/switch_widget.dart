// import 'package:flutter/material.dart';

// class OnlineOfflineButton extends StatefulWidget {
//   const OnlineOfflineButton({super.key});

//   @override
//   State<OnlineOfflineButton> createState() => _OnlineOfflineButtonState();
// }

// class _OnlineOfflineButtonState extends State<OnlineOfflineButton> {
//   bool isOnline = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isOnline = !isOnline;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isOnline ? Colors.green.shade400 : Colors.grey.shade300,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 10,
//               height: 10,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//             ),
//             const SizedBox(width: 6),
//             Text(
//               isOnline ? 'Online' : 'Offline',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
