import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/screens/home_screen.dart';
import 'signup_page.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  final bool fromGuest;

  const LoginPage({
    super.key,
    this.fromGuest = false,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberPassword = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful'),
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
                        const SizedBox(height: 80),

                        Center(
                          child: Image.asset(
                            'assets/images/loven-logo.png',
                            width: 130,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Welcome back to LOVEN!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFB39DDB),
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Login to continue',
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
                            vertical: 48,
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
                                const Text(
                                  'Email',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),

                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: inputDecoration('Type your email'),
                                  enabled: !isLoading,
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

                                const SizedBox(height: 24),

                                const Text(
                                  'Password',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),

                                TextFormField(
                                  controller: passwordController,
                                  obscureText: obscurePassword,
                                  enabled: !isLoading,
                                  decoration: inputDecoration(
                                    'Type your password',
                                  ).copyWith(
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
                                                obscurePassword =
                                                    !obscurePassword;
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

                                const SizedBox(height: 16),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: rememberPassword,
                                      onChanged: isLoading
                                          ? null
                                          : (value) {
                                              setState(() {
                                                rememberPassword =
                                                    value ?? false;
                                              });
                                            },
                                    ),
                                    const Text(
                                      'Remember me',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 40),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFFEDE7F6),
                                      foregroundColor: Colors.black,
                                      disabledBackgroundColor:
                                          const Color(0xFFEDE7F6),
                                      disabledForegroundColor: Colors.black,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const Text('Logging in...')
                                        : const Text('Login'),
                                  ),
                                ),

                                const SizedBox(height: 28),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Don't have an account? "),
                                    GestureDetector(
                                      onTap: isLoading
                                          ? null
                                          : () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignupPage(
                                                    fromGuest:
                                                        widget.fromGuest,
                                                  ),
                                                ),
                                              );
                                            },
                                      child: const Text(
                                        'Sign up!',
                                        style: TextStyle(
                                          color: Colors.red,
                                          decoration:
                                              TextDecoration.underline,
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