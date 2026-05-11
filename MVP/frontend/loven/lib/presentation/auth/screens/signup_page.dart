import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'terms_page.dart';
import 'privacy_policy_page.dart';
import '../../home/screens/home_screen.dart';
import 'login_page.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class SignupPage extends StatefulWidget {
  final bool fromGuest;

  const SignupPage({
    super.key,
    this.fromGuest = false,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool acceptedTerms = false;
  bool obscurePassword = true;

  String selectedRole = 'customer';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _signup() {
    if (!_formKey.currentState!.validate()) return;

    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please accept the terms and privacy policy'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    context.read<AuthCubit>().signup(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          systemRole: selectedRole,
        );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
      filled: true,
      fillColor: const Color(0xFFEAEAEA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }

void _goToGuestHome() {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => const HomeScreen(isGuest: true),
    ),
    (route) => false,
  );
}

  void _goToLoggedInHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully'),
            ),
          );

          _goToLoggedInHome();
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 60),

                        Center(
                          child: Image.asset(
                            'assets/images/loven-logo.png',
                            width: 130,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Create your LOVEN account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFB39DDB),
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Join as a customer or artist',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 32),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 44,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(40),
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Full Name', style: TextStyle(fontSize: 16)),
                                const SizedBox(height: 8),

                                TextFormField(
                                  controller: nameController,
                                  enabled: !isLoading,
                                  decoration: inputDecoration('Type your full name'),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Name is required';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 20),

                                const Text('Email', style: TextStyle(fontSize: 16)),
                                const SizedBox(height: 8),

                                TextFormField(
                                  controller: emailController,
                                  enabled: !isLoading,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: inputDecoration('Type your email'),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Email is required';
                                    }

                                    if (!value.contains('@')) {
                                      return 'Enter a valid email';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 20),

                                const Text('Password', style: TextStyle(fontSize: 16)),
                                const SizedBox(height: 8),

                                TextFormField(
                                  controller: passwordController,
                                  enabled: !isLoading,
                                  obscureText: obscurePassword,
                                  decoration: inputDecoration('Type your password').copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              setState(() {
                                                obscurePassword = !obscurePassword;
                                              });
                                            },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required';
                                    }

                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters';
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 20),

                                const Text('Role', style: TextStyle(fontSize: 16)),
                                const SizedBox(height: 8),

                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAEAEA),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedRole,
                                      isExpanded: true,
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'customer',
                                          child: Text('Customer'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'artist',
                                          child: Text('Artist'),
                                        ),
                                      ],
                                      onChanged: isLoading
                                          ? null
                                          : (value) {
                                              setState(() {
                                                selectedRole = value!;
                                              });
                                            },
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: acceptedTerms,
                                      onChanged: isLoading
                                          ? null
                                          : (value) {
                                              setState(() {
                                                acceptedTerms = value ?? false;
                                              });
                                            },
                                    ),
                                    Flexible(
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                          children: [
                                            const TextSpan(text: 'I agree to the '),
                                            WidgetSpan(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => const TermsPage(),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'terms and conditions',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    decoration: TextDecoration.underline,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const TextSpan(text: ' and '),
                                            WidgetSpan(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const PrivacyPolicyPage(),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'privacy policy',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    decoration: TextDecoration.underline,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 36),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _signup,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEDE7F6),
                                      foregroundColor: Colors.black,
                                      disabledBackgroundColor: const Color(0xFFEDE7F6),
                                      disabledForegroundColor: Colors.black,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const Text('Creating account...')
                                        : const Text('Create Account'),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Already have an account? '),
                                    GestureDetector(
                                      onTap: isLoading
                                          ? null
                                          : () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => LoginPage(
                                                    fromGuest: widget.fromGuest,
                                                  ),
                                                ),
                                              );
                                            },
                                      child: const Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.red,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 16,
                  right: 16,
                  child: SafeArea(
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 28,
                        color: Colors.black,
                      ),
                      onPressed: _goToGuestHome,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}