import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import 'about_oloni_bank_screen.dart';
import 'help_support_screen.dart';
import 'login_screen.dart';
import 'transaction_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> account;

  const ProfileScreen({super.key, required this.account});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  XFile? _profileImage;

  // =============================================================
  // ACCOUNT-SPECIFIC PROFILE IMAGE KEY
  // =============================================================

  String get _profileImageKey {
    final accountNumber = widget.account['account_number']?.toString() ?? '';

    return 'profile_image_$accountNumber';
  }

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // =============================================================
  // LOAD PROFILE IMAGE
  // =============================================================

  Future<void> _loadProfileImage() async {
    final preferences = await SharedPreferences.getInstance();

    // Each account gets its own profile image key.
    final savedPath = preferences.getString(_profileImageKey);

    if (savedPath == null || savedPath.isEmpty) {
      return;
    }

    final imageFile = File(savedPath);

    if (!imageFile.existsSync()) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _profileImage = XFile(savedPath);
    });
  }

  // =============================================================
  // PICK PROFILE IMAGE
  // =============================================================

  Future<void> _pickProfileImage() async {
    final selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (selectedImage == null) {
      return;
    }

    final preferences = await SharedPreferences.getInstance();

    // Save the image against THIS user's account number.
    await preferences.setString(_profileImageKey, selectedImage.path);

    if (!mounted) {
      return;
    }

    setState(() {
      _profileImage = selectedImage;
    });
  }

  // =============================================================
  // HEADER
  // =============================================================

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF100A24),
              border: Border.all(
                color: const Color(0xFF8A2BE2).withValues(alpha: 0.40),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),

        const Expanded(
          child: Center(
            child: Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF100A24),
            border: Border.all(
              color: const Color(0xFF8A2BE2).withValues(alpha: 0.40),
            ),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: Color(0xFFFFA63D),
            size: 22,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // PROFILE HEADER
  // =============================================================

  Widget _buildProfileHeader(String name, String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A20),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF8A2BE2).withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A2BE2).withValues(alpha: 0.06),
            blurRadius: 25,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // PROFILE PHOTO
          GestureDetector(
            onTap: _pickProfileImage,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 105,
                  height: 105,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF8A00),
                        Color(0xFFFF4FA3),
                        Color(0xFF8A2BE2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF8A00).withValues(alpha: 0.18),
                        blurRadius: 25,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF100A24),
                    ),
                    child: _profileImage == null
                        ? const Icon(
                            Icons.person_rounded,
                            color: Colors.white70,
                            size: 52,
                          )
                        : ClipOval(
                            child: Image.file(
                              File(_profileImage!.path),
                              width: 99,
                              height: 99,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),

                Container(
                  width: 31,
                  height: 31,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF8A00),
                    border: Border.all(
                      color: const Color(0xFF0F0A20),
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            email,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),

          const SizedBox(height: 12),

          GestureDetector(
            onTap: _pickProfileImage,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8A00).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFF8A00).withValues(alpha: 0.16),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, color: Color(0xFFFFA63D), size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Change profile photo',
                    style: TextStyle(
                      color: Color(0xFFFFA63D),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // ACCOUNT SUMMARY
  // =============================================================

  Widget _buildAccountSummary() {
    final accountNumber = widget.account['account_number']?.toString() ?? '';

    final accountType = widget.account['account_type']?.toString() ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF8A00).withValues(alpha: 0.08),
            const Color(0xFF8A2BE2).withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: const Color(0xFFFF8A00).withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF100A24),
                  border: Border.all(
                    color: const Color(0xFFFF8A00).withValues(alpha: 0.20),
                  ),
                ),
                child: const Icon(
                  Icons.account_balance_outlined,
                  color: Color(0xFFFFA63D),
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Oloni Bank Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Your primary banking account',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.greenAccent,
                      size: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),

          Divider(color: Colors.white.withValues(alpha: 0.07)),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _buildAccountInfo('Account Number', accountNumber),
              ),

              Container(
                width: 1,
                height: 35,
                color: Colors.white.withValues(alpha: 0.08),
              ),

              Expanded(
                child: _buildAccountInfo(
                  'Account Type',
                  accountType,
                  centered: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(
    String title,
    String value, {
    bool centered = false,
  }) {
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white30, fontSize: 10),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          textAlign: centered ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // SECTION TITLE
  // =============================================================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 3, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }

  // =============================================================
  // INFO CARD
  // =============================================================

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A20),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF8A2BE2).withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1C1630),
              border: Border.all(
                color: const Color(0xFFFF8A00).withValues(alpha: 0.20),
              ),
            ),
            child: Icon(icon, color: const Color(0xFFFFA63D), size: 20),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white30, fontSize: 10),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // MENU ITEM
  // =============================================================

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool disabled = false,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Opacity(
        opacity: disabled ? 0.55 : 1,
        child: Container(
          margin: const EdgeInsets.only(bottom: 9),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0A20),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF8A2BE2).withValues(alpha: 0.16),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1C1630),
                ),
                child: Icon(icon, color: const Color(0xFFFFA63D), size: 20),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white30,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              Icon(
                disabled
                    ? Icons.lock_outline_rounded
                    : Icons.arrow_forward_ios_rounded,
                color: Colors.white24,
                size: disabled ? 16 : 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // LOGOUT
  // =============================================================

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0A20),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF8A2BE2).withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent.withValues(alpha: 0.07),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: 25,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Log out of Oloni Bank?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'You will need to sign in again to access your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),

                const SizedBox(height: 21),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    await ApiService().logout();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // =============================================================
  // BUILD
  // =============================================================

  @override
  Widget build(BuildContext context) {
    final name = widget.account['name']?.toString() ?? 'Oloni Customer';

    final email = widget.account['email']?.toString() ?? '';

    final phoneNumber = widget.account['phone_number']?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF050117),

      body: Stack(
        children: [
          // =======================================================
          // ORANGE GLOW
          // =======================================================

          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF8A00).withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // =======================================================
          // PURPLE GLOW
          // =======================================================
          Positioned(
            top: 350,
            left: -120,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8A2BE2).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // =======================================================
          // CONTENT
          // =======================================================
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),

                  const SizedBox(height: 22),

                  _buildProfileHeader(name, email),

                  const SizedBox(height: 16),

                  _buildAccountSummary(),

                  const SizedBox(height: 25),

                  // PERSONAL INFORMATION
                  _buildSectionTitle('PERSONAL INFORMATION'),

                  _buildInfoCard(
                    icon: Icons.person_outline_rounded,
                    title: 'Full Name',
                    value: name,
                  ),

                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    title: 'Email Address',
                    value: email,
                  ),

                  if (phoneNumber.isNotEmpty)
                    _buildInfoCard(
                      icon: Icons.phone_outlined,
                      title: 'Phone Number',
                      value: phoneNumber,
                    ),

                  const SizedBox(height: 16),

                  // ACCOUNT
                  _buildSectionTitle('ACCOUNT'),

                  _buildMenuItem(
                    icon: Icons.receipt_long_outlined,
                    title: 'Transaction History',
                    subtitle: 'View your banking activity',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const TransactionHistoryScreen(),
                        ),
                      );
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    subtitle: 'Coming in a future update',
                    disabled: true,
                    onTap: () {},
                  ),

                  const SizedBox(height: 16),

                  // SUPPORT
                  _buildSectionTitle('SUPPORT'),

                  _buildMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    subtitle: 'Get help with Oloni Bank',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpSupportScreen(),
                        ),
                      );
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About Oloni Bank',
                    subtitle: 'Learn more about Oloni Bank',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutOloniBankScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 17),

                  // LOGOUT
                  GestureDetector(
                    onTap: _logout,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF160A19),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.redAccent.withValues(alpha: 0.20),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.redAccent,
                            size: 19,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'Your money. Your control.',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 11,
                            letterSpacing: 1.4,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          'OLONI BANK',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
