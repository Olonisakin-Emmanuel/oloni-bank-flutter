import 'package:flutter/material.dart';

class AboutOloniBankScreen extends StatelessWidget {
  const AboutOloniBankScreen({super.key});

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
          'About Oloni Bank',
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

        padding: const EdgeInsets.fromLTRB(20, 15, 20, 40),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // BRAND HERO
            // =====================================================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),

                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF211344), Color(0xFF0F0A20)],
                ),

                border: Border.all(color: purpleColor.withValues(alpha: 0.28)),

                boxShadow: [
                  BoxShadow(
                    color: purpleColor.withValues(alpha: 0.10),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),

              child: Column(
                children: [
                  // =================================================
                  // LOGO
                  // =================================================

                  Container(
                    width: 115,
                    height: 115,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: const Color(0xFF0B0717),

                      border: Border.all(
                        color: orangeColor.withValues(alpha: 0.18),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: orangeColor.withValues(alpha: 0.18),
                          blurRadius: 30,
                          spreadRadius: 4,
                        ),
                      ],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(18),

                      child: Image.asset(
                        'assets/images/oloni_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'OLONI BANK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'More than banking. A better way of living.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: orangeColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    height: 1,
                    width: 70,
                    color: orangeColor.withValues(alpha: 0.45),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'A personal banking technology project',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'Designed, engineered and built from the '
                    'backend up.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =====================================================
            // ABOUT THE PROJECT
            // =====================================================
            _buildSectionTitle(
              icon: Icons.auto_awesome_rounded,
              title: 'About the Project',
            ),

            const SizedBox(height: 12),

            _buildTextCard(
              child: const Text(
                'Oloni Bank is a personal banking technology project '
                'created to explore how modern financial services can '
                'be designed, built and delivered through a seamless '
                'digital experience.\n\n'
                'The system was developed from the backend and database '
                'up before being connected to a Flutter mobile '
                'application.\n\n'
                'Oloni Bank combines Flutter, Python, FastAPI and '
                'PostgreSQL to create a complete banking experience '
                'covering authentication, account management, deposits, '
                'withdrawals, transfers and transaction history.\n\n'
                'The project focuses on understanding how the different '
                'layers of a real-world financial application work '
                'together from database design and APIs to '
                'authentication, business logic and mobile user '
                'experience.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.7,
                ),
              ),
            ),
            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: orangeColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: orangeColor.withValues(alpha: 0.20)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: orangeColor.withValues(alpha: 0.10),
                    ),
                    child: const Icon(
                      Icons.info_outline_rounded,
                      color: orangeColor,
                      size: 19,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fictional Banking Application',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          'Oloni Bank is a fictional banking application '
                          'created strictly for educational, demonstration '
                          'and portfolio purposes. It is not a real financial '
                          'institution and is not affiliated with any bank or '
                          'financial institution.',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // =====================================================
            // TECHNOLOGY STACK
            // =====================================================
            _buildSectionTitle(
              icon: Icons.code_rounded,
              title: 'Technology Stack',
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildTechnologyCard(
                    icon: Icons.phone_android_rounded,
                    name: 'Flutter',
                    description: 'Mobile UI',
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _buildTechnologyCard(
                    icon: Icons.code_rounded,
                    name: 'Python',
                    description: 'Backend',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildTechnologyCard(
                    icon: Icons.api_rounded,
                    name: 'FastAPI',
                    description: 'REST API',
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _buildTechnologyCard(
                    icon: Icons.storage_rounded,
                    name: 'PostgreSQL',
                    description: 'Database',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // =====================================================
            // WHAT THE SYSTEM DOES
            // =====================================================
            _buildSectionTitle(
              icon: Icons.account_balance_rounded,
              title: 'What Oloni Bank Does',
            ),

            const SizedBox(height: 12),

            _buildTextCard(
              child: Column(
                children: [
                  _buildSystemFeature(
                    icon: Icons.lock_outline_rounded,
                    title: 'Authentication',
                    description:
                        'Secure user login and protected account access.',
                  ),

                  _buildSystemFeature(
                    icon: Icons.person_outline_rounded,
                    title: 'Account Management',
                    description: 'Create and manage customer banking accounts.',
                  ),

                  _buildSystemFeature(
                    icon: Icons.add_card_rounded,
                    title: 'Deposits',
                    description: 'Add funds and update account balances.',
                  ),

                  _buildSystemFeature(
                    icon: Icons.money_off_rounded,
                    title: 'Withdrawals',
                    description:
                        'Withdraw funds securely using transaction PIN.',
                  ),

                  _buildSystemFeature(
                    icon: Icons.swap_horiz_rounded,
                    title: 'Transfers',
                    description: 'Transfer money between Oloni Bank accounts.',
                  ),

                  _buildSystemFeature(
                    icon: Icons.receipt_long_outlined,
                    title: 'Transaction History',
                    description:
                        'View and inspect completed financial transactions.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // =====================================================
            // THE PURPOSE
            // =====================================================
            _buildSectionTitle(
              icon: Icons.lightbulb_outline_rounded,
              title: 'The Purpose',
            ),

            const SizedBox(height: 12),

            _buildTextCard(
              child: const Text(
                'Oloni Bank was built as a practical exploration of '
                'how a modern digital banking system works as a complete '
                'technology product.\n\n'
                'The project brings together mobile development, '
                'backend engineering, API design, database management, '
                'authentication and financial transaction processing '
                'within one connected system.\n\n'
                'The goal is to move beyond simply designing a banking '
                'interface and understand how the technology behind '
                'the experience actually works.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // =====================================================
            // WHAT'S NEXT
            // =====================================================
            _buildSectionTitle(
              icon: Icons.rocket_launch_rounded,
              title: "What's Next",
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),

                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF241047), Color(0xFF120A25)],
                ),

                border: Border.all(color: orangeColor.withValues(alpha: 0.22)),

                boxShadow: [
                  BoxShadow(
                    color: orangeColor.withValues(alpha: 0.06),
                    blurRadius: 25,
                    spreadRadius: 1,
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // VERSION 2.0 HEADER
                  // =================================================

                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          color: orangeColor.withValues(alpha: 0.10),

                          border: Border.all(
                            color: orangeColor.withValues(alpha: 0.25),
                          ),
                        ),

                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: orangeColor,
                          size: 22,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          'Oloni Bank 2.0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'The next evolution of Oloni Bank will explore '
                    'AI-powered capabilities designed to make banking '
                    'more intelligent, personalized and useful.',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =================================================
                  // FUTURE FEATURES
                  // =================================================
                  _buildFutureFeature(
                    icon: Icons.smart_toy_outlined,
                    text: 'AI-powered banking assistance',
                  ),

                  _buildFutureFeature(
                    icon: Icons.mic_none_rounded,
                    text: 'Voice-enabled banking',
                  ),

                  _buildFutureFeature(
                    icon: Icons.insights_outlined,
                    text: 'Intelligent financial insights',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =====================================================
            // BUILDER CREDIT
            // =====================================================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: purpleColor.withValues(alpha: 0.14)),
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: orangeColor.withValues(alpha: 0.10),
                    ),

                    child: const Icon(
                      Icons.engineering_rounded,
                      color: orangeColor,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Built by',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),

                        SizedBox(height: 4),

                        Text(
                          'Emmanuel Olonisakin',
                          style: TextStyle(
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
            ),

            const SizedBox(height: 30),

            // =====================================================
            // VERSION
            // =====================================================
            Center(
              child: Column(
                children: [
                  Container(
                    width: 45,
                    height: 1,
                    color: purpleColor.withValues(alpha: 0.30),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'OLONI BANK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Built with purpose. Designed for the future.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // SECTION TITLE
  // =============================================================

  Widget _buildSectionTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: orangeColor.withValues(alpha: 0.10),
          ),

          child: Icon(icon, color: orangeColor, size: 18),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // =============================================================
  // TEXT CARD
  // =============================================================

  Widget _buildTextCard({required Widget child}) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: purpleColor.withValues(alpha: 0.16)),
      ),

      child: child,
    );
  }

  // =============================================================
  // TECHNOLOGY CARD
  // =============================================================

  Widget _buildTechnologyCard({
    required IconData icon,
    required String name,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: purpleColor.withValues(alpha: 0.16)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: orangeColor.withValues(alpha: 0.10),
            ),

            child: Icon(icon, color: orangeColor, size: 20),
          ),

          const SizedBox(height: 12),

          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SYSTEM FEATURE
  // =============================================================

  Widget _buildSystemFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: orangeColor.withValues(alpha: 0.10),
            ),

            child: Icon(icon, color: orangeColor, size: 19),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    height: 1.4,
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
  // FUTURE FEATURE
  // =============================================================

  Widget _buildFutureFeature({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),

      child: Row(
        children: [
          Icon(icon, color: orangeColor, size: 18),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
