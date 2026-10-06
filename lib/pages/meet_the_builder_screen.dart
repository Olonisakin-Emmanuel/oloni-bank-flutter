import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MeetTheBuilderScreen extends StatefulWidget {
  const MeetTheBuilderScreen({super.key});

  @override
  State<MeetTheBuilderScreen> createState() => _MeetTheBuilderScreenState();
}

class _MeetTheBuilderScreenState extends State<MeetTheBuilderScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050117),
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
          'Meet the Builder',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
        child: Column(
          children: [
            _buildHero(),
            const SizedBox(height: 35),
            _buildStory(),
            const SizedBox(height: 35),
            _buildCapabilities(),
            const SizedBox(height: 35),
            _buildOloniBank(),
            const SizedBox(height: 35),
            _buildMindset(),
            const SizedBox(height: 35),
            _buildFuture(),
            const SizedBox(height: 35),
            _buildConnect(),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // HERO
  // =============================================================

  Widget _buildHero() {
    return Column(
      children: [
        const SizedBox(height: 15),

        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOut,
          builder: (context, opacity, child) {
            return Opacity(opacity: opacity, child: child);
          },
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final t = _animationController.value;

              final rotation = t * 2 * math.pi;

              double glow = 0.0;

              if (t >= 0.62 && t < 0.78) {
                final glowProgress = (t - 0.62) / 0.16;
                glow = math.sin(glowProgress * math.pi);
              }

              double pulse = 0.0;

              if (t >= 0.82 && t < 1.0) {
                final pulseProgress = (t - 0.82) / 0.18;
                pulse = math.sin(pulseProgress * math.pi);
              }

              final glowBlur = 25 + (glow * 22) + (pulse * 8);
              final glowSpread = 2 + (glow * 4) + (pulse * 2);

              final ringOpacity = 0.82 + (glow * 0.18);

              final photoScale = 1.0 + (pulse * 0.015);

              return SizedBox(
                width: 205,
                height: 205,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: rotation,
                      child: Opacity(
                        opacity: ringOpacity,
                        child: Image.asset(
                          'assets/images/oloni_orbital_ring.png',
                          width: 205,
                          height: 205,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    Container(
                      width: 157,
                      height: 157,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF8A00).withValues(
                              alpha: 0.10 + (glow * 0.16) + (pulse * 0.04),
                            ),
                            blurRadius: glowBlur,
                            spreadRadius: glowSpread,
                          ),
                          BoxShadow(
                            color: const Color(0xFF8A2BE2)
                                .withValues(alpha: 0.08 + (glow * 0.10)),
                            blurRadius: glowBlur + 10,
                            spreadRadius: glowSpread,
                          ),
                        ],
                      ),
                    ),

                    Transform.scale(
                      scale: photoScale,
                      child: Container(
                        width: 148,
                        height: 148,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFF8A00),
                              Color(0xFFFF4D8D),
                              Color(0xFF8A2BE2),
                            ],
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/emmanuel_olonisakin.png',
                            width: 142,
                            height: 142,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 25),

        const Text(
          'MEET THE BUILDER',
          style: TextStyle(
            color: Color(0xFFFF8A00),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Emmanuel Olonisakin',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'AI • Data • Software • Product Development',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 25),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0A20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF8A2BE2).withValues(alpha: 0.22),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8A2BE2).withValues(alpha: 0.06),
                blurRadius: 25,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Text(
            '"I don\'t just learn technology. '
            'I build with it."',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFF8A00),
              fontSize: 20,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // STORY
  // =============================================================

  Widget _buildStory() {
    return _section(
      title: 'My Story',
      icon: Icons.auto_awesome_rounded,
      child: const Text(
        'I started my career in Civil Engineering, where I developed '
        'a strong foundation in analytical thinking and problem-solving.\n\n'
        'But I became increasingly interested in technology and how '
        'data, artificial intelligence and software can be used to '
        'solve real-world problems.\n\n'
        'So I taught myself programming, data analysis, machine '
        'learning, backend development and mobile app development '
        'and more importantly, started turning what I learned into '
        'actual products.',
        style: TextStyle(color: Colors.white, fontSize: 17, height: 1.7),
      ),
    );
  }

  // =============================================================
  // CAPABILITIES
  // =============================================================

  Widget _buildCapabilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeading(title: 'What I Build', icon: Icons.code_rounded),

        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: _capabilityCard(
                icon: Icons.psychology_rounded,
                title: 'AI & Data',
                items: [
                  'Python',
                  'Data Analysis',
                  'Machine Learning',
                  'AI Applications',
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _capabilityCard(
                icon: Icons.developer_mode_rounded,
                title: 'Software',
                items: ['Python', 'FastAPI', 'REST APIs', 'PostgreSQL'],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _capabilityCard(
                icon: Icons.phone_android_rounded,
                title: 'Product',
                items: ['Flutter', 'Dart', 'Mobile Apps', 'API Integration'],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _capabilityCard(
                icon: Icons.lightbulb_outline_rounded,
                title: 'Mindset',
                items: [
                  'Problem Solving',
                  'Systems Thinking',
                  'Analysis',
                  'Continuous Learning',
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =============================================================
  // CAPABILITY CARD
  // =============================================================

  Widget _capabilityCard({
    required IconData icon,
    required String title,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A20),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF8A2BE2).withValues(alpha: 0.16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFFF8A00), size: 24),

          const SizedBox(height: 11),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 9),

          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                '• $item',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            );
          }),
        ],
      ),
    );
  }

  // =============================================================
  // OLONI BANK
  // =============================================================

  Widget _buildOloniBank() {
    return _section(
      title: 'Oloni Bank',
      icon: Icons.account_balance_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A banking system I built from the backend up.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0A20),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFFF8A00).withValues(alpha: 0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF8A00).withValues(alpha: 0.06),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                _architectureBox(
                  icon: Icons.phone_android_rounded,
                  title: 'Flutter + Dart',
                  subtitle: 'Mobile Application',
                ),

                _architectureArrow(),

                _architectureBox(
                  icon: Icons.api_rounded,
                  title: 'FastAPI',
                  subtitle: 'REST API Layer',
                ),

                _architectureArrow(),

                _architectureBox(
                  icon: Icons.code_rounded,
                  title: 'Python',
                  subtitle: 'Backend & Business Logic',
                ),

                _architectureArrow(),

                _architectureBox(
                  icon: Icons.storage_rounded,
                  title: 'PostgreSQL',
                  subtitle: 'Database',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'What the system handles',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              _featureCard(
                icon: Icons.lock_outline_rounded,
                title: 'Authentication',
              ),
              _featureCard(
                icon: Icons.person_outline_rounded,
                title: 'Accounts',
              ),
              _featureCard(icon: Icons.add_card_rounded, title: 'Deposits'),
              _featureCard(icon: Icons.money_off_rounded, title: 'Withdrawals'),
              _featureCard(icon: Icons.swap_horiz_rounded, title: 'Transfers'),
              _featureCard(
                icon: Icons.receipt_long_outlined,
                title: 'Transactions',
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF8A00).withValues(alpha: 0.10),
                  const Color(0xFF8A2BE2).withValues(alpha: 0.10),
                ],
              ),
              border: Border.all(
                color: const Color(0xFFFF8A00).withValues(alpha: 0.14),
              ),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.engineering_rounded,
                  color: Color(0xFFFF8A00),
                  size: 22,
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Text(
                    'Built from the backend up — not just designed from the frontend.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A00).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFF8A00).withValues(alpha: 0.16),
              ),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFFFF8A00),
                  size: 19,
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fictional Banking Technology Project',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        'Educational • Demonstration • Portfolio',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
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
  // ENGINEERING MINDSET
  // =============================================================

  Widget _buildMindset() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeading(
          title: 'How I Build',
          icon: Icons.build_circle_outlined,
        ),

        const SizedBox(height: 15),

        _mindsetCard(
          number: '01',
          title: 'BUILD',
          text: 'I turn what I learn into working products.',
        ),

        _mindsetCard(
          number: '02',
          title: 'SOLVE',
          text: 'I approach problems by understanding how the pieces fit together.',
        ),

        _mindsetCard(
          number: '03',
          title: 'IMPROVE',
          text: 'I test, refine and keep improving until the system works the way it should.',
        ),
      ],
    );
  }

  // =============================================================
  // FUTURE
  // =============================================================

  Widget _buildFuture() {
    return _section(
      title: 'What I\'m Building Towards',
      icon: Icons.rocket_launch_rounded,
      child: const Text(
        'I\'m interested in the intersection of AI, data, financial '
        'technology and product development.\n\n'
        'My goal is to build intelligent products that don\'t just '
        'work, but solve meaningful problems for people and businesses.\n\n'
        'This is only the beginning. I\'m continuously learning, '
        'building and refining new ideas. More projects will be '
        'added as they reach the standard I want them to.',
        style: TextStyle(color: Colors.white, fontSize: 16, height: 1.7),
      ),
    );
  }

  // =============================================================
  // CONNECT
  // =============================================================

  Widget _buildConnect() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF241047), Color(0xFF0F0A20)],
        ),
        border: Border.all(
          color: const Color(0xFFFF8A00).withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8A00).withValues(alpha: 0.08),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'LET\'S BUILD SOMETHING',
            style: TextStyle(
              color: Color(0xFFFF8A00),
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'I\'m looking for opportunities where I can learn '
            'from strong teams, solve meaningful problems and '
            'contribute to products that matter.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16, height: 1.6),
          ),

          const SizedBox(height: 22),

          _contactButton(
            icon: Icons.business_center_outlined,
            text: 'Connect With Me',
            onPressed: () {
              _openLink('https://www.linkedin.com/in/olonisakin-emmanuel/');
            },
          ),

          const SizedBox(height: 22),

          const Text(
            'Built by Emmanuel Olonisakin',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),

          const SizedBox(height: 5),

          const Text(
            'AI & Technology • Data • Machine Learning • Product Development',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SECTION
  // =============================================================

  Widget _section({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A20),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF8A2BE2).withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeading(title: title, icon: icon),

          const SizedBox(height: 15),

          child,
        ],
      ),
    );
  }

  // =============================================================
  // SECTION HEADING
  // =============================================================

  Widget _buildSectionHeading({required String title, required IconData icon}) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFF8A00).withValues(alpha: 0.10),
          ),
          child: Icon(icon, color: const Color(0xFFFF8A00), size: 19),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // =============================================================
  // ARCHITECTURE BOX
  // =============================================================

  Widget _architectureBox({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF17102F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF8A00).withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF8A00).withValues(alpha: 0.10),
            ),
            child: Icon(icon, color: const Color(0xFFFF8A00), size: 20),
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

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // ARCHITECTURE ARROW
  // =============================================================

  Widget _architectureArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Center(
        child: Icon(
          Icons.arrow_downward_rounded,
          color: Color(0xFFFF8A00),
          size: 18,
        ),
      ),
    );
  }

  // =============================================================
  // FEATURE CARD
  // =============================================================

  Widget _featureCard({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF17102F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFF8A00).withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFFF8A00), size: 17),

          const SizedBox(width: 7),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // MINDSET CARD
  // =============================================================

  Widget _mindsetCard({
    required String number,
    required String title,
    required String text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A20),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFF8A2BE2).withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Color(0xFFFF8A00),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
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
  // CONTACT BUTTON
  // =============================================================

  Widget _contactButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: const Color(0xFFFF8A00), size: 19),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(
            color: const Color(0xFFFF8A00).withValues(alpha: 0.30),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
