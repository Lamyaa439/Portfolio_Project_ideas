import 'package:flutter/material.dart';
import '../home/screens/home_screen.dart';
import '../auth/screens/login_page.dart';
import '../auth/screens/signup_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  bool _showWelcome = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    fadeAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );

    scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );

    controller.forward();
    _startWelcomePhase();
  }

  Future<void> _startWelcomePhase() async {
    // Wait for the logo animation to settle before showing text
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _showWelcome = true;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // MAIN CONTENT AREA
          Center(
            child: SingleChildScrollView(
              // Prevents overflow on smaller screens
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ANIMATED LOGO
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: ScaleTransition(
                      scale: scaleAnimation,
                      child: Image.asset(
                        'assets/images/loven-logo.png',
                        width: 210,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // WELCOME CONTENT (Fades in after delay)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: _showWelcome ? 1.0 : 0.0,
                    child: _buildWelcomeActions(),
                  ),
                ],
              ),
            ),
          ),

          // PERSISTENT GUEST ACCESS (At the bottom)
          if (_showWelcome)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Text(
                    "Browse as Guest",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWelcomeActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            'A space for every creative soul',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Whatever your art, this is your space to sell, inspire, and be seen.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 40),

          // LOGIN BUTTON
          ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage())),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.black, // Adjust based on your brand colors
              foregroundColor: Colors.white,
              fixedSize: const Size(260, 55),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Login", style: TextStyle(fontSize: 16)),
          ),

          const SizedBox(height: 16),

          // SIGN UP BUTTON
          OutlinedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignupPage())),
            style: OutlinedButton.styleFrom(
              fixedSize: const Size(260, 55),
              side: const BorderSide(color: Colors.black12, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
