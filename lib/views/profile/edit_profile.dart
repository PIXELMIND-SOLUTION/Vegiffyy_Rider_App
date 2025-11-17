// // lib/views/profile/edit_profile.dart
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:veggify_delivery_app/global/toast.dart';
// import 'package:veggify_delivery_app/provider/Profile/profile_provider.dart';

// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});

//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
//   final ImagePicker _picker = ImagePicker();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   String _vehicleType = '';

//   @override
//   void initState() {
//     super.initState();

//     // Load profile after first frame so provider is available
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final provider = context.read<ProfileProvider>();
//       provider.loadProfile().then((_) {
//         final p = provider.profile;
//         if (p != null) {
//           _nameController.text = p.fullName;
//           _phoneController.text = p.mobileNumber;
//           _emailController.text = p.email ?? '';
//           _vehicleType = p.vehicleType;
//           setState(() {});
//         }
//       }).catchError((e) {
//         GlobalToast.showError('Failed to load profile: $e');
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickAndUploadProfileImage() async {
//     try {
//       final picked = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1600,
//         maxHeight: 1600,
//         imageQuality: 85,
//       );
//       if (picked == null) return;

//       final file = File(picked.path);
//       final provider = context.read<ProfileProvider>();
//       final ok = await provider.uploadProfileImage(file);
//       if (ok) {
//         GlobalToast.showSuccess('Profile image updated');
//       } else {
//         GlobalToast.showError(provider.errorMessage ?? 'Upload failed');
//       }
//     } catch (e) {
//       GlobalToast.showError('Error picking/uploading image: $e');
//     }
//   }

//   void _showPreview(String? imageUrl) {
//     if (imageUrl == null || imageUrl.isEmpty) {
//       GlobalToast.showInfo('No document uploaded');
//       return;
//     }

//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: const EdgeInsets.all(16),
//         child: Stack(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: InteractiveViewer(
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.contain,
//                   loadingBuilder: (context, child, progress) {
//                     if (progress == null) return child;
//                     return SizedBox(
//                       height: 240,
//                       child: const Center(child: CircularProgressIndicator()),
//                     );
//                   },
//                   errorBuilder: (context, err, st) {
//                     return SizedBox(
//                       height: 240,
//                       child: Center(
//                         child: Text('Failed to load image', style: TextStyle(color: Colors.white)),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 8,
//               right: 8,
//               child: IconButton(
//                 icon: const Icon(Icons.close, color: Colors.white),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildReadOnlyField({
//     required String label,
//     required TextEditingController controller,
//     String? hint,
//     Widget? suffix,
//   }) {
//     return TextField(
//       controller: controller,
//       enabled: false, // read-only for now
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         suffixIcon: suffix,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProfileProvider>(
//       builder: (context, provider, _) {
//         final profile = provider.profile;
//         final state = provider.state;

//         return Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: Colors.white,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//               onPressed: () => Navigator.pop(context),
//             ),
//             title: const Text(
//               "Personal information",
//               style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
//             ),
//             centerTitle: false,
//           ),
//           body: state == ProfileState.loading && profile == null
//               ? const Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 6),
//                       Center(
//                         child: Stack(
//                           children: [
//                             CircleAvatar(
//                               radius: 48,
//                               backgroundColor: Colors.grey.shade200,
//                               backgroundImage: profile?.profileImage != null
//                                   ? NetworkImage(profile!.profileImage!)
//                                   : const AssetImage('assets/home.png') as ImageProvider,
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: GestureDetector(
//                                 onTap: _pickAndUploadProfileImage,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue,
//                                     shape: BoxShape.circle,
//                                     border: Border.all(color: Colors.white, width: 2),
//                                   ),
//                                   padding: const EdgeInsets.all(8),
//                                   child: const Icon(Icons.edit, color: Colors.white, size: 18),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 18),

//                       // Fields (read-only now)
//                       _buildReadOnlyField(label: 'Full Name', controller: _nameController, hint: 'Full name'),
//                       const SizedBox(height: 12),
//                       _buildReadOnlyField(label: 'Phone Number', controller: _phoneController),
//                       const SizedBox(height: 12),
//                       _buildReadOnlyField(label: 'Email', controller: _emailController),
//                       const SizedBox(height: 12),

//                       // Vehicle type – read-only chip style
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('Vehicle type *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
//                             const SizedBox(height: 8),
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey.shade400),
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: Colors.grey.shade50,
//                               ),
//                               child: Text(
//                                 _vehicleType.isNotEmpty ? _vehicleType : (profile?.vehicleType ?? '—'),
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       // Documents section - show name + eye icon to preview if uploaded
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text('Uploaded Documents', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
//                       ),
//                       const SizedBox(height: 12),

//                       _buildDocRow('Aadhaar Card', profile?.aadharCard, onView: () => _showPreview(profile?.aadharCard)),
//                       const SizedBox(height: 10),
//                       _buildDocRow('Driving License', profile?.drivingLicense, onView: () => _showPreview(profile?.drivingLicense)),

//                       const SizedBox(height: 28),

//                       // Save button is disabled because API for non-image updates not yet provided
//                       SizedBox(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: null, // disabled until you provide update API
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.grey.shade400,
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                           ),
//                           child: const Text('Save (disabled)', style: TextStyle(color: Colors.white)),
//                         ),
//                       ),

//                       const SizedBox(height: 16),
//                       if (state == ProfileState.updating) const LinearProgressIndicator(),
//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//         );
//       },
//     );
//   }

//   Widget _buildDocRow(String label, String? url, {required VoidCallback onView}) {
//     final has = url != null && url.isNotEmpty;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
//       child: Row(
//         children: [
//           Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
//           if (has)
//             IconButton(
//               onPressed: onView,
//               icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
//             )
//           else
//             TextButton(
//               onPressed: () => GlobalToast.showInfo('Not uploaded'),
//               child: const Text('Not uploaded'),
//             ),
//         ],
//       ),
//     );
//   }
// }





















// lib/views/profile/edit_profile.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:veggify_delivery_app/global/toast.dart';
import 'package:veggify_delivery_app/provider/Profile/profile_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(); // read only
  final TextEditingController _emailController = TextEditingController();
  String _vehicleType = '';

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Load profile after first frame so provider is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProfileProvider>();
      provider.loadProfile().then((_) {
        final p = provider.profile;
        if (p != null) {
          _nameController.text = p.fullName ?? '';
          _phoneController.text = p.mobileNumber ?? '';
          _emailController.text = p.email ?? '';
          _vehicleType = p.vehicleType ?? '';
          setState(() {});
        }
      }).catchError((e) {
        GlobalToast.showError('Failed to load profile: $e');
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadProfileImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked == null) return;

      final file = File(picked.path);
      final provider = context.read<ProfileProvider>();
      final ok = await provider.uploadProfileImage(file);
      if (ok) {
        GlobalToast.showSuccess('Profile image updated');
      } else {
        GlobalToast.showError(provider.errorMessage ?? 'Upload failed');
      }
    } catch (e) {
      GlobalToast.showError('Error picking/uploading image: $e');
    }
  }

  void _showPreview(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      GlobalToast.showInfo('No document uploaded');
      return;
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      height: 240,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, err, st) {
                    return SizedBox(
                      height: 240,
                      child: Center(
                        child: Text('Failed to load image', style: TextStyle(color: Colors.white)),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required TextEditingController controller,
    String? hint,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      enabled: false, // read-only for phone
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDocRow(String label, String? url, {required VoidCallback onView}) {
    final has = url != null && url.isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
          if (has)
            IconButton(
              onPressed: onView,
              icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
            )
          else
            TextButton(
              onPressed: () => GlobalToast.showInfo('Not uploaded'),
              child: const Text('Not uploaded'),
            ),
        ],
      ),
    );
  }

  Future<void> _onSave() async {
    final provider = context.read<ProfileProvider>();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty) {
      GlobalToast.showError('Name cannot be empty');
      return;
    }

    setState(() {
      _isSaving = true;
    });
print("ooooooooooooooooooooooooooooooooo$name");
print("ooooooooooooooooooooooooooooooooo$email");

    final ok = await provider.updateProfile(fullName: name, email: email.isEmpty ? null : email);

    setState(() {
      _isSaving = false;
    });

    if (ok) {
      GlobalToast.showSuccess('Profile updated successfully');
      // Optionally pop
      Navigator.of(context).pop();
    } else {
      GlobalToast.showError(provider.errorMessage ?? 'Failed to update profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final profile = provider.profile;
        final state = provider.state;

        // if profile loaded after provider.loadProfile, ensure controllers are in sync
        if (profile != null) {
          // only update controllers if they are blank to avoid overwriting user's typing
          if (_nameController.text.isEmpty) _nameController.text = profile.fullName ?? '';
          if (_phoneController.text.isEmpty) _phoneController.text = profile.mobileNumber ?? '';
          if (_emailController.text.isEmpty) _emailController.text = profile.email ?? '';
          if (_vehicleType.isEmpty) _vehicleType = profile.vehicleType ?? '';
        }

        final isUpdating = state == ProfileState.updating || _isSaving;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Personal information",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: false,
          ),
          body: state == ProfileState.loading && profile == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 6),
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: profile?.profileImage != null
                                  ? NetworkImage(profile!.profileImage!)
                                  : const AssetImage('assets/home.png') as ImageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickAndUploadProfileImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(Icons.edit, color: Colors.white, size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Editable full name
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Full name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Phone read-only
                      _buildReadOnlyField(label: 'Phone Number', controller: _phoneController),
                      const SizedBox(height: 12),

                      // Email editable
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'you@example.com',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),

                      // Vehicle type – read-only chip style
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Vehicle type *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade50,
                              ),
                              child: Text(
                                _vehicleType.isNotEmpty ? _vehicleType : (profile?.vehicleType ?? '—'),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Documents section - show name + eye icon to preview if uploaded
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Uploaded Documents', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 8),
                      // Note that documents can only be updated by admin
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Text(
                          'Documents can only be updated through admin. Contact support for document changes.',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),

                      _buildDocRow('Aadhaar Card', profile?.aadharCard, onView: () => _showPreview(profile?.aadharCard)),
                      const SizedBox(height: 10),
                      _buildDocRow('Driving License', profile?.drivingLicense, onView: () => _showPreview(profile?.drivingLicense)),

                      const SizedBox(height: 28),

                      // Save button - enabled
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isUpdating ? null : _onSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isUpdating ? Colors.grey.shade400 : Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: isUpdating
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white), strokeWidth: 2))
                              : const Text('Save', style: TextStyle(color: Colors.white)),
                        ),
                      ),

                      const SizedBox(height: 16),
                      if (state == ProfileState.updating) const LinearProgressIndicator(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
