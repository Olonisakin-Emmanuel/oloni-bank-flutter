import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'meet_the_builder_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050117),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: const Color(0xFF050117)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, right: 4),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Skip',
                      style: TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                Text(
                  'Welcome to',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Oloni Bank',
                  style: TextStyle(
                    color: const Color(0xFFFF8A00),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 70),
                Image.asset('assets/images/oloni_welcome.png', width: 300),
                const SizedBox(height: 20),
                Text(
                  'More than banking. A better way of living.',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8A00),
                    foregroundColor: Colors.white,
                    elevation: 8,
                    minimumSize: Size(
                      MediaQuery.of(context).size.width - 40,
                      55,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MeetTheBuilderScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFF8A00)),
                    foregroundColor: Colors.white,
                    elevation: 8,
                    minimumSize: Size(
                      MediaQuery.of(context).size.width - 40,
                      55,
                    ),
                  ),
                  child: Text(
                    'Explore',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
