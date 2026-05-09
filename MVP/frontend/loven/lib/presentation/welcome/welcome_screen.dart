import 'package:flutter/material.dart';
import '../auth/screens/login_page.dart';
import '../auth/screens/signup_page.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 90),

            Image.asset(
              'assets/images/loven-logo.png',
              width: 150,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 24),

            const Text(
              'LOVEN',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: Color(0xFFB39DDB),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'A space for every creative soul',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),

            const Spacer(),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 48,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Whatever your art, this is your space to sell, inspire, and be seen.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 36),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupPage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.black26),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text('Create Account'),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.black26),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text('Login'),
                        ),
                      ),
                    ],
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