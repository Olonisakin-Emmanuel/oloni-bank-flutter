import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'account_created_screen.dart';

class SignupSecurityScreen extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String email;
  final String password;

  const SignupSecurityScreen({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  @override
  State<SignupSecurityScreen> createState() => _SignupSecurityScreenState();
}

class _SignupSecurityScreenState extends State<SignupSecurityScreen> {
  final pinController = TextEditingController();
  final confirmPinController = TextEditingController();

  bool isPinVisible = false;
  bool isConfirmPinVisible = false;
  bool isLoading = false;

  String accountType = 'Savings';

  Future<void> validateAndContinue() async {
    final pin = pinController.text.trim();
    final confirmPin = confirmPinController.text.trim();

    if (pin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN must be exactly 4 digits')),
      );
      return;
    }

    if (confirmPin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN confirmation must be exactly 4 digits'),
        ),
      );
      return;
    }

    if (pin != confirmPin) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('PINs do not match')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    final data = await ApiService().createAccount(
      name: widget.name,
      phoneNumber: widget.phoneNumber,
      email: widget.email,
      password: widget.password,
      accountType: accountType,
      pin: pin,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (data != null && data['error'] != true) {
      final accountNumber = data['account_number'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AccountCreatedScreen(
            accountNumber: accountNumber,
            name: widget.name,
            accountType: accountType,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            data?['message'] ?? 'Account creation failed. Please try again.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    confirmPinController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050117),
      body: Stack(
        children: [
          // =========================
          // SPACE BACKGROUND
          // =========================

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 500,
            child: Image.asset(
              'assets/images/signup2.png',
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),

          // =========================
          // DARK GRADIENT
          // =========================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00070707), Color(0xFF070707)],
                ),
              ),
            ),
          ),

          // =========================
          // PAGE CONTENT
          // =========================
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                // =========================
                // OLONI BRAND HEADER
                // =========================

                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF8A00)
                                  .withValues(alpha: 0.12),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                            BoxShadow(
                              color: const Color(0xFF8A2BE2)
                                  .withValues(alpha: 0.10),
                              blurRadius: 40,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/oloni_logo1.png',
                          width: 140,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Secure Your Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'Set up your security details and choose your account type.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // =========================
                // PIN
                // =========================
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      '4-Digit PIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    obscureText: !isPinVisible,
                    maxLength: 4,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      letterSpacing: 4,
                    ),
                    cursorColor: const Color(0xFFFF8A00),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Enter your 4-digit PIN',
                      hintStyle: const TextStyle(
                        color: Colors.white38,
                        fontSize: 14,
                        letterSpacing: 0,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white54,
                        size: 21,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPinVisible = !isPinVisible;
                          });
                        },
                        icon: Icon(
                          isPinVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white54,
                          size: 21,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF100A24),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 17,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: const Color(0xFFFF8A00)
                              .withValues(alpha: 0.55),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // =========================
                // CONFIRM PIN
                // =========================
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      'Confirm PIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: confirmPinController,
                    keyboardType: TextInputType.number,
                    obscureText: !isConfirmPinVisible,
                    maxLength: 4,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      letterSpacing: 4,
                    ),
                    cursorColor: const Color(0xFFFF8A00),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Re-enter your 4-digit PIN',
                      hintStyle: const TextStyle(
                        color: Colors.white38,
                        fontSize: 14,
                        letterSpacing: 0,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white54,
                        size: 21,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isConfirmPinVisible = !isConfirmPinVisible;
                          });
                        },
                        icon: Icon(
                          isConfirmPinVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white54,
                          size: 21,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF100A24),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 17,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: const Color(0xFFFF8A00)
                              .withValues(alpha: 0.55),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // =========================
                // ACCOUNT TYPE
                // =========================
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      'Account Type',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: DropdownButtonFormField<String>(
                    initialValue: accountType,
                    dropdownColor: const Color(0xFF15102A),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white54,
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.account_balance_outlined,
                        color: Colors.white54,
                        size: 21,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF100A24),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 17,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: const Color(0xFFFF8A00)
                              .withValues(alpha: 0.55),
                          width: 1.2,
                        ),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Savings',
                        child: Text('Savings'),
                      ),
                      DropdownMenuItem(
                        value: 'Current',
                        child: Text('Current'),
                      ),
                    ],
                    onChanged: isLoading
                        ? null
                        : (value) {
                            if (value == null) return;

                            setState(() {
                              accountType = value;
                            });
                          },
                  ),
                ),

                const SizedBox(height: 30),

                // =========================
                // CREATE ACCOUNT BUTTON
                // =========================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : validateAndContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8A00),
                      disabledBackgroundColor: const Color(0xFFFF8A00)
                          .withValues(alpha: 0.55),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      elevation: 8,
                      shadowColor: const Color(0xFFFF8A00)
                          .withValues(alpha: 0.25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 40),

                // EXTRA SPACE FOR BACKGROUND
                const SizedBox(height: 220),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
