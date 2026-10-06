import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const Color backgroundColor = Color(0xFF050117);
  static const Color cardColor = Color(0xFF0F0A20);
  static const Color orangeColor = Color(0xFFFF8A00);
  static const Color purpleColor = Color(0xFF8A2BE2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // =========================================================
      // APP BAR
      // =========================================================
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),

        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =====================================================
            // HEADER CARD
            // =====================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),

                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF211344), Color(0xFF0F0A20)],
                ),

                border: Border.all(color: purpleColor.withValues(alpha: 0.30)),

                boxShadow: [
                  BoxShadow(
                    color: purpleColor.withValues(alpha: 0.08),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(
                    width: 54,
                    height: 54,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1C1630),

                      border: Border.all(
                        color: orangeColor.withValues(alpha: 0.35),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: orangeColor.withValues(alpha: 0.12),
                          blurRadius: 15,
                        ),
                      ],
                    ),

                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: orangeColor,
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'How can we help you?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Find quick answers to common questions '
                    'about your Oloni Bank account.',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =====================================================
            // COMMON QUESTIONS
            // =====================================================
            const Text(
              'COMMON QUESTIONS',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.4,
              ),
            ),

            const SizedBox(height: 14),

            _buildHelpItem(
              icon: Icons.lock_outline_rounded,
              title: 'Login & Account',
              question: 'How do I log into my Oloni Bank account?',
              answer:
                  'Enter your registered email address and password '
                  'on the login screen. Once your details are verified, '
                  'you will be taken to your dashboard.',
            ),

            _buildHelpItem(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Deposits & Withdrawals',
              question: 'How do I deposit or withdraw money?',
              answer:
                  'From your dashboard, select Deposit or Withdraw. '
                  'Enter the amount and follow the instructions shown '
                  'on the screen to complete the transaction.',
            ),

            _buildHelpItem(
              icon: Icons.swap_horiz_rounded,
              title: 'Transfers',
              question: 'How do I transfer money?',
              answer:
                  'Select Transfer from the dashboard. Enter the '
                  'recipient account number, confirm the recipient name, '
                  'enter the amount and provide your transaction PIN '
                  'to complete the transfer.',
            ),

            _buildHelpItem(
              icon: Icons.receipt_long_outlined,
              title: 'Transactions',
              question: 'Where can I see my transaction history?',
              answer:
                  'Open your Profile and select Transaction History. '
                  'You can view your deposits, transfers and withdrawals, '
                  'and tap any transaction to see its details.',
            ),

            _buildHelpItem(
              icon: Icons.person_outline_rounded,
              title: 'Profile & Account',
              question: 'Where can I view my account information?',
              answer:
                  'Open your Profile from the dashboard. Your personal '
                  'information and available account features can be '
                  'accessed from there.',
            ),

            const SizedBox(height: 25),

            // =====================================================
            // CONTACT SUPPORT CARD
            // =====================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),

                border: Border.all(color: orangeColor.withValues(alpha: 0.20)),
              ),

              child: Column(
                children: [
                  Container(
                    width: 54,
                    height: 54,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1C1630),

                      border: Border.all(
                        color: orangeColor.withValues(alpha: 0.25),
                      ),
                    ),

                    child: const Icon(
                      Icons.headset_mic_rounded,
                      color: orangeColor,
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Still need help?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'Our support team will be happy to assist you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // CONTACT BUTTON
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: () {
                        _showSupportDialog(context);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangeColor,
                        foregroundColor: Colors.black,
                        elevation: 0,

                        padding: const EdgeInsets.symmetric(vertical: 15),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),

                      child: const Text(
                        'Contact Oloni Support',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =====================================================
            // FOOTER
            // =====================================================
            const Center(
              child: Text(
                'Oloni Bank • Help Centre',
                style: TextStyle(color: Colors.white24, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // SUPPORT DIALOG
  // =============================================================

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F0A20),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: const Column(
            children: [
              Icon(
                Icons.headset_mic_rounded,
                color: Color(0xFFFF8A00),
                size: 38,
              ),

              SizedBox(height: 12),

              Text(
                'Oloni Support',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const Text(
                'Need assistance? You can reach our support team through:',
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 22),

              // =================================================
              // EMAIL SUPPORT
              // =================================================
              _buildContactOption(
                icon: Icons.email_outlined,
                title: 'Email Support',
                value: 'olonisakinemmanuel5@gmail.com',

                onTap: () async {
                  final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: 'olonisakinemmanuel5@gmail.com',
                    queryParameters: {'subject': 'Oloni Bank Support'},
                  );

                  if (await canLaunchUrl(emailUri)) {
                    await launchUrl(emailUri);
                  }
                },
              ),

              const SizedBox(height: 12),

              // =================================================
              // PHONE SUPPORT
              // =================================================
              _buildContactOption(
                icon: Icons.phone_outlined,
                title: 'Call Support',
                value: '09039299570',

                onTap: () async {
                  final Uri phoneUri = Uri(scheme: 'tel', path: '09039299570');

                  if (await canLaunchUrl(phoneUri)) {
                    await launchUrl(phoneUri);
                  }
                },
              ),
            ],
          ),

          // =====================================================
          // CLOSE BUTTON
          // =====================================================
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color(0xFFFF8A00),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =============================================================
  // CONTACT OPTION
  // =============================================================

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: const Color(0xFF17102F),

          borderRadius: BorderRadius.circular(16),

          border: Border.all(color: purpleColor.withValues(alpha: 0.20)),
        ),

        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,

              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1C1630),
              ),

              child: Icon(icon, color: orangeColor, size: 21),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    value,

                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white38,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // HELP ITEM
  // =============================================================

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: purpleColor.withValues(alpha: 0.18)),
      ),

      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),

        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),

          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 18),

          leading: Container(
            width: 42,
            height: 42,

            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1C1630),
            ),

            child: Icon(icon, color: orangeColor, size: 21),
          ),

          title: Text(
            title,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          trailing: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white54,
          ),

          children: [
            Align(
              alignment: Alignment.centerLeft,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    question,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Text(
                    answer,

                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
