// lib/views/profile/profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:veggify_delivery_app/provider/Profile/profile_provider.dart';
import 'package:veggify_delivery_app/views/hystory/order_hystory_screen.dart';
import 'package:veggify_delivery_app/views/profile/edit_profile.dart';
import 'package:veggify_delivery_app/global/toast.dart';
import 'package:veggify_delivery_app/views/auth/login_screen.dart';
import 'package:veggify_delivery_app/views/profile/settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ImagePicker _picker;
  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();

    // load profile via provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProfileProvider>();
      provider.loadProfile();
    });
  }

  Future<void> _pickAndUploadImage() async {
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

  Future<void> _handleLogout() async {
    final provider = context.read<ProfileProvider>();
    await provider.logout();
    // navigate to login and clear stack
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.trending_up, color: Colors.black),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.state == ProfileState.loading || provider.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == ProfileState.error && provider.profile == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Failed to load profile: ${provider.errorMessage ?? ''}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => provider.loadProfile(),
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          }

          final profile = provider.profile!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                // Profile Image and Info
                Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: profile.profileImage != null
                              ? NetworkImage(profile.profileImage!)
                              : const AssetImage('assets/home.png') as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickAndUploadImage,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.edit, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(profile.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(profile.email ?? '-', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    Text(profile.mobileNumber, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (profile.deliveryBoyStatus.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              profile.deliveryBoyStatus,
                              style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w600),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Wallet ₹${profile.walletBalance.toStringAsFixed(0)}',
                            style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),

                _buildProfileTile(
                  icon: Icons.person_outline,
                  title: 'Personal information',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile()));
                  },
                ),
                                _buildProfileTile(
                  icon: Icons.history,
                  title: 'Order History',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderHistoryScreen()));
                  },
                ),
                _buildProfileTile(
                  icon: Icons.history,
                  title: 'Settings',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LocationSettingsScreen()));
                  },
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                _buildProfileTile(icon: Icons.help_outline, title: 'Need Help?', onTap: () {}),
                _buildProfileTile(icon: Icons.phone_outlined, title: 'Contact Us', onTap: () {}),
                const SizedBox(height: 20),
                // Logout Button
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
                    onTap: _handleLogout,
                  ),
                ),
                const SizedBox(height: 24),
                if (provider.state == ProfileState.updating) const LinearProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: onTap,
      ),
    );
  }
}
