// lib/screens/signup_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:veggify_delivery_app/global/toast.dart';
import 'package:veggify_delivery_app/provider/Auth/signup_provider.dart';
import 'package:veggify_delivery_app/views/auth/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  File? _drivingLicenseImage;
  File? _aadharCardImage;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _obscurePassword = true;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignupProvider>().resetState();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Future<void> _pickImage(bool isProfile) async {
  //   try {
  //     XFile? picked;

  //     if (isProfile) {
  //       picked = await _picker.pickImage(
  //         source: ImageSource.camera,
  //         preferredCameraDevice: CameraDevice.front,
  //         maxWidth: 1800,
  //         maxHeight: 1800,
  //         imageQuality: 85,
  //       );
  //     } else {
  //       final source = await _showImageSourceDialog();
  //       if (source == null) return;

  //       picked = await _picker.pickImage(
  //         source: source,
  //         maxWidth: 1800,
  //         maxHeight: 1800,
  //         imageQuality: 85,
  //       );
  //     }

  //     if (picked != null) {
  //       if (!mounted) return;
  //       // setState(() {
  //       //   if (isProfile) {
  //       //     _profileImage = File(picked.path);
  //       //   } else {
  //       //     _drivingLicenseImage = File(picked.path);
  //       //   }
  //       // });
  //       context.read<SignupProvider>().clearError();
  //       GlobalToast.showSuccess('Image selected');
  //     } else {
  //       // user cancelled - optional notice
  //       // GlobalToast.showInfo('Image selection cancelled');
  //     }
  //   } catch (e) {
  //     GlobalToast.showError('Error picking image: $e');
  //   }
  // }

  Future<void> _pickImage(bool isProfile) async {
    try {
      XFile? picked; // rename to avoid confusion

      if (isProfile) {
        picked = await _picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
          maxWidth: 1800,
          maxHeight: 1800,
          imageQuality: 85,
        );
      } else {
        final source = await _showImageSourceDialog();
        if (source == null) return;

        picked = await _picker.pickImage(
          source: source,
          maxWidth: 1800,
          maxHeight: 1800,
          imageQuality: 85,
        );
      }

      // ✅ Absolutely safe: path used ONLY when picked != null
      if (picked != null) {
        setState(() {
          if (isProfile) {
            _profileImage = File(picked!.path);
          } else {
            _drivingLicenseImage = File(picked!.path);
          }
        });
        context.read<SignupProvider>().clearError();
        GlobalToast.showSuccess('Image selected');
      } else {
        // Optional: user canceled
        GlobalToast.showInfo('Image selection cancelled');
      }
    } catch (e) {
      GlobalToast.showError('Error picking image: $e');
    }
  }

  Future<void> _pickAadhar() async {
    final source = await _showImageSourceDialog();
    if (source == null) return;

    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() => _aadharCardImage = File(picked.path));
      GlobalToast.showSuccess("Aadhaar added");
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.green[600]),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.green[600]),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLocalToast(String message, {bool isError = false}) {
    if (isError)
      GlobalToast.showError(message);
    else
      GlobalToast.showSuccess(message);
  }

  Future<void> _handleSignup() async {
    final signupProvider = context.read<SignupProvider>();
    signupProvider.clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_profileImage == null) {
      _showLocalToast('Please upload your profile picture', isError: true);
      setState(() => _currentStep = 0);
      return;
    }

    if (_drivingLicenseImage == null) {
      _showLocalToast('Please upload your driving license', isError: true);
      setState(() => _currentStep = 1);
      return;
    }

    final success = await signupProvider.signupRider(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      vehicleType: 'Bike', // change if selectable
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      aadharPath: _aadharCardImage?.path,
      drivingLicensePath: _drivingLicenseImage?.path,
      profileImage: _profileImage?.path,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      _showLocalToast('Account created successfully!');
      await Future.delayed(const Duration(milliseconds: 800));
      // navigate to login or home
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    } else {
      final msg = signupProvider.errorMessage ?? 'Signup failed';
      _showLocalToast(msg, isError: true);
    }
  }

  String? _validateName(String? value) {
    final provider = context.read<SignupProvider>();
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (!provider.isValidName(value))
      return 'Name must be at least 2 characters';
    return null;
  }

  String? _validateEmail(String? value) {
    final provider = context.read<SignupProvider>();
    if (value == null || value.trim().isEmpty) return null; // optional
    if (!provider.isValidEmail(value)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePhone(String? value) {
    final provider = context.read<SignupProvider>();
    if (value == null || value.trim().isEmpty)
      return 'Phone number is required';
    if (!provider.isValidPhone(value)) return 'Enter a valid phone number';
    return null;
  }

  String? _validatePassword(String? value) {
    final provider = context.read<SignupProvider>();
    if (value == null || value.trim().isEmpty) return 'Password is required';
    if (!provider.isValidPassword(value)) {
      return 'Password must include uppercase, lowercase, number, and special character';
    }
    return null;
  }

  Widget _buildStepIndicator(int step, String label, IconData icon) {
    final isActive = _currentStep >= step;
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.green[600] : Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int step) {
    final isActive = _currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 24),
        color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
      ),
    );
  }

  Widget _buildProfileStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Upload Your Photo',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Take a selfie for verification',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => _pickImage(true),
              child: Stack(
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _profileImage == null
                            ? Colors.grey[300]!
                            : Colors.green[600]!,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: _profileImage == null
                        ? Icon(
                            Icons.person_outline,
                            size: 70,
                            color: Colors.grey[400],
                          )
                        : ClipOval(
                            child: Image.file(_profileImage!, fit: BoxFit.cover),
                          ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.green[600],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _profileImage == null ? Icons.camera_alt : Icons.edit,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_profileImage != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Photo uploaded successfully!',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  Text(
                    'Tap the camera icon to take selfie',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.blue[700],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Selfie camera will open automatically',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAadharStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Aadhaar Card',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload the front side of Aadhaar',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 30),

          GestureDetector(
            onTap: _pickAadhar,
            child: Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _aadharCardImage == null
                      ? Colors.grey[300]!
                      : Colors.green[600]!,
                  width: _aadharCardImage == null ? 2 : 3,
                ),
              ),
              child: _aadharCardImage == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.credit_card,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text("Upload Aadhaar", style: TextStyle(fontSize: 16)),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        _aadharCardImage!,
                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Driving License',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Required for delivery verification',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () => _pickImage(false),
            child: Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _drivingLicenseImage == null
                      ? Colors.grey[300]!
                      : Colors.green[600]!,
                  width: _drivingLicenseImage == null ? 2 : 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _drivingLicenseImage == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Upload License',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Take a clear photo of your license',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            _drivingLicenseImage!,
                            width: double.infinity,
                            height: 280,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Row(
                            children: [
                              _buildIconButton(
                                Icons.close,
                                () =>
                                    setState(() => _drivingLicenseImage = null),
                              ),
                              const SizedBox(width: 8),
                              _buildIconButton(
                                Icons.edit,
                                () => _pickImage(false),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          if (_drivingLicenseImage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'License uploaded successfully!',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Personal Details',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete your profile information',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),
          _buildCompactTextField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: _validateName,
          ),
          const SizedBox(height: 16),
          _buildCompactTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildCompactTextField(
            controller: _phoneController,
            label: 'Phone',
            icon: Icons.phone_outlined,
            validator: _validatePhone,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildCompactTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            validator: _validatePassword,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green[600]),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green[600]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 20),
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Consumer<SignupProvider>(
          builder: (context, signupProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (signupProvider.state == SignupState.error &&
                  signupProvider.errorMessage != null) {
                GlobalToast.showError(signupProvider.errorMessage!);
              }
            });

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  '🥗 Join Our Delivery Team',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Deliver fresh veg meals & earn',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildStepIndicator(0, 'Profile', Icons.person),
                          _buildStepLine(0),
                          _buildStepIndicator(1, 'Aadhar', Icons.credit_card),
                          _buildStepLine(1),
                          _buildStepIndicator(2, 'License', Icons.badge),
                          _buildStepLine(2),
                          _buildStepIndicator(3, 'Details', Icons.info),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Form(
                    key: _formKey,
                    child: IndexedStack(
                      index: _currentStep,
                      children: [
                        _buildProfileStep(),
                        _buildAadharStep(),

                        _buildLicenseStep(),
                        _buildDetailsStep(),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _currentStep--),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.green[600]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Back'),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          // inside your build -> ElevatedButton
onPressed: signupProvider.isLoading
    ? null
    : () {
        const lastStepIndex = 3; // 0=Profile,1=Aadhar,2=License,3=Details

        // If not on last step, validate current step and advance
        if (_currentStep < lastStepIndex) {
          // step-specific validations
          if (_currentStep == 0 && _profileImage == null) {
            GlobalToast.showError("Please upload profile photo");
            return;
          }
          if (_currentStep == 1 && _aadharCardImage == null) {
            GlobalToast.showError("Please upload Aadhaar card");
            return;
          }
          if (_currentStep == 2 && _drivingLicenseImage == null) {
            GlobalToast.showError("Please upload driving license");
            return;
          }

          setState(() {
            _currentStep = (_currentStep + 1).clamp(0, lastStepIndex);
          });

          // debug line (remove in production)
          // print('Moved to step $_currentStep');
        } else {
          // last step -> submit
          _handleSignup();
        }
      },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: signupProvider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  _currentStep < 3 ? 'Next' : 'Create Account',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
