import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login_screen.dart';

class AccountCreatedScreen extends StatelessWidget {
  final dynamic accountNumber;
  final String name;
  final String accountType;

  const AccountCreatedScreen({
    super.key,
    required this.accountNumber,
    required this.name,
    required this.accountType,
  });

  @override
  Widget build(BuildContext context) {
    final accountNumberText = accountNumber.toString();

    return Scaffold(
      backgroundColor: const Color(0xFF050117),
      body: SafeArea(
        child: Stack(
          children: [
            // =========================
            // BACKGROUND GLOW
            // =========================

            Positioned(
              top: 80,
              left: -80,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8A2BE2).withValues(alpha: 0.10),
                      blurRadius: 120,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 250,
              right: -100,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF8A00).withValues(alpha: 0.08),
                      blurRadius: 120,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),

            // =========================
            // MAIN CONTENT
            // =========================
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // =========================
                    // OLONI LOGO
                    // =========================
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

                    const SizedBox(height: 45),

                    // =========================
                    // SUCCESS ICON
                    // =========================
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFFFF8A00).withValues(alpha: 0.20),
                            const Color(0xFFFF4FA3).withValues(alpha: 0.12),
                            const Color(0xFF8A2BE2).withValues(alpha: 0.15),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFFFF8A00)
                              .withValues(alpha: 0.55),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF8A00)
                                .withValues(alpha: 0.16),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF100A24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Color(0xFFFFA63D),
                          size: 46,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // =========================
                    // SUCCESS TITLE
                    // =========================
                    const Text(
                      'Account Created!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Welcome to Oloni Bank, $name',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Your banking journey starts here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white38, fontSize: 13),
                    ),

                    const SizedBox(height: 32),

                    // =========================
                    // ACCOUNT CARD
                    // =========================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFF100A24),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: const Color(0xFFFF8A00)
                              .withValues(alpha: 0.20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.20),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // CARD HEADER
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFF8A00)
                                      .withValues(alpha: 0.10),
                                  border: Border.all(
                                    color: const Color(0xFFFF8A00)
                                        .withValues(alpha: 0.15),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.account_balance_rounded,
                                  color: Color(0xFFFFA63D),
                                  size: 21,
                                ),
                              ),

                              const SizedBox(width: 12),

                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your Oloni Bank Account',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      'Account successfully created',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // ACCOUNT NUMBER LABEL
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'ACCOUNT NUMBER',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ACCOUNT NUMBER
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  accountNumberText,
                                  style: const TextStyle(
                                    color: Color(0xFFFFA63D),
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),

                              IconButton(
                                tooltip: 'Copy account number',
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: accountNumberText),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Account number copied'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.copy_rounded,
                                  color: Colors.white54,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // DIVIDER
                          Container(
                            height: 1,
                            color: Colors.white.withValues(alpha: 0.06),
                          ),

                          const SizedBox(height: 18),

                          // ACCOUNT TYPE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Account Type',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                accountType,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // =========================
                    // SECURITY MESSAGE
                    // =========================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF100A24).withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_user_outlined,
                            color: Colors.greenAccent,
                            size: 20,
                          ),

                          const SizedBox(width: 12),

                          const Expanded(
                            child: Text(
                              'Keep your account number and PIN secure. Never share your PIN with anyone.',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    // =========================
                    // CONTINUE BUTTON
                    // =========================
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8A00),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: const Color(0xFFFF8A00)
                              .withValues(alpha: 0.25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Continue to Login',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
