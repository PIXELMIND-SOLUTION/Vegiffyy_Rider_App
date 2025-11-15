// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:veggify_delivery_app/views/navbar/navbar_screen.dart';
// import 'dart:io';

// import 'package:veggify_delivery_app/views/auth/splash_screen.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   String? selectedVehicleType;
//   final List<String> vehicleTypes = ['Bike', 'Scooter', 'Car', 'Bicycle'];
//   final ImagePicker _picker = ImagePicker();
//   File? aadharImage;
//   File? licenseImage;

//   Future<void> pickImage(String type) async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         if (type == 'aadhar') {
//           aadharImage = File(image.path);
//         } else {
//           licenseImage = File(image.path);
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 // Hero Image
//                 Center(
//                   child: Container(
//                     width: 200,
//                     height: 200,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       shape: BoxShape.circle,
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(30.0),
//                       child: Image.asset(
//                         'assets/registerimage.png',
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 // Title
//                 const Text(
//                   'Become a',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const Text(
//                   'Delivery Hero',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 // Full Name Field
//                 const Text(
//                   'Full Name*',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Enter your name',
//                     hintStyle: TextStyle(color: Colors.grey[400]),
//                     filled: true,
//                     fillColor: Colors.grey[50],
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(color: Colors.green, width: 2),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Mobile Number Field
//                 const Text(
//                   'Mobile Number*',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     hintText: 'Type your mobile number',
//                     hintStyle: TextStyle(color: Colors.grey[400]),
//                     filled: true,
//                     fillColor: Colors.grey[50],
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(color: Colors.green, width: 2),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Vehicle Type Dropdown
//                 const Text(
//                   'Vehicle Type*',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 DropdownButtonFormField<String>(
//                   value: selectedVehicleType,
//                   hint: Text(
//                     'Select',
//                     style: TextStyle(color: Colors.grey[400]),
//                   ),
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: Colors.grey[50],
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(color: Colors.green, width: 2),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                   ),
//                   items: vehicleTypes.map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       selectedVehicleType = newValue;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 // Upload Aadhar Card
//                 InkWell(
//                   onTap: () => pickImage('aadhar'),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       border: Border.all(color: Colors.grey[300]!),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: aadharImage != null
//                               ? Row(
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(4),
//                                       child: Image.file(
//                                         aadharImage!,
//                                         width: 40,
//                                         height: 40,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Text(
//                                         'Aadhar Card Uploaded',
//                                         style: TextStyle(
//                                           color: Colors.grey[700],
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               : Text(
//                                   'Upload Aadhar Card',
//                                   style: TextStyle(
//                                     color: Colors.grey[400],
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                         ),
//                         Icon(
//                           Icons.upload_outlined,
//                           color: Colors.grey[600],
//                           size: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Upload Driving License
//                 InkWell(
//                   onTap: () => pickImage('license'),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       border: Border.all(color: Colors.grey[300]!),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: licenseImage != null
//                               ? Row(
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(4),
//                                       child: Image.file(
//                                         licenseImage!,
//                                         width: 40,
//                                         height: 40,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Text(
//                                         'Driving License Uploaded',
//                                         style: TextStyle(
//                                           color: Colors.grey[700],
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               : Text(
//                                   'Upload Driving License',
//                                   style: TextStyle(
//                                     color: Colors.grey[400],
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                         ),
//                         Icon(
//                           Icons.upload_outlined,
//                           color: Colors.grey[600],
//                           size: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 // Register Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {

//                                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>NavbarScreen()));

//                       // Handle registration
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF4CAF50),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       elevation: 0,
//                     ),
//                     child: const Text(
//                       'Register',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Already have Account
//                 Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'Already have Account ',
//                         style: TextStyle(
//                           color: Colors.black87,
//                           fontSize: 14,
//                         ),
//                       ),
//                       InkWell(
//                         onTap: () {

//                           Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashScreen()));
//                           // Navigate to login
//                         },
//                         child: const Text(
//                           'Login',
//                           style: TextStyle(
//                             color: Color(0xFF4CAF50),
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }