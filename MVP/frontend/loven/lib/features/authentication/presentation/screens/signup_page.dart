import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loven/core/router/app_router.dart';
import 'terms_page.dart';
import 'privacy_policy_page.dart';
<<<<<<< HEAD:MVP/frontend/loven/lib/features/authentication/presentation/screens/signup_page.dart
import 'package:loven/presentation/home/screens/home_screen.dart';
=======
>>>>>>> 045abf936f665ebb8b405b2debbba7b44ccea53a:MVP/frontend/loven/lib/presentation/auth/screens/signup_page.dart
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

    final theme = Theme.of(context);

    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please accept the terms and privacy policy'),
          backgroundColor: theme.colorScheme.error,
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

  InputDecoration inputDecoration(String hint, ThemeData theme) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest,
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

  void _handleCloseAction() {
    // 🎯 Use GoRouter pop or return home cleanly to maintain router history control
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  void _goToLoggedInHome() {
    // 🎯 BREAK THE GUEST LOOP:
    // Flip the dynamic global boolean to false before triggering redirection
    isUserBrowsingAsGuest = false;

    // Use GoRouter to rebuild navigation context cleanly from the root state
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              backgroundColor: theme.colorScheme.error,
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
            backgroundColor: theme.scaffoldBackgroundColor,
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
                        Text(
                          'Create your LOVEN account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
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
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLow,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(40),
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Full Name',
                                    style: TextStyle(fontSize: 16)),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: nameController,
                                  enabled: !isLoading,
                                  decoration: inputDecoration(
                                      'Type your full name', theme),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Name is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                const Text('Email',
                                    style: TextStyle(fontSize: 16)),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: emailController,
                                  enabled: !isLoading,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration:
                                      inputDecoration('Type your email', theme),
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
                                const Text('Password',
                                    style: TextStyle(fontSize: 16)),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: passwordController,
                                  enabled: !isLoading,
                                  obscureText: obscurePassword,
                                  decoration: inputDecoration(
                                          'Type your password', theme)
                                      .copyWith(
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
                                const SizedBox(height: 20),
                                const Text('Role',
                                    style: TextStyle(fontSize: 16)),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: theme
                                        .colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedRole,
                                      isExpanded: true,
                                      dropdownColor: theme
                                          .colorScheme.surfaceContainerHighest,
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
                                      activeColor: theme.colorScheme.primary,
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
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                            fontSize: 12,
                                          ),
                                          children: [
                                            const TextSpan(
                                                text: 'I agree to the '),
                                            WidgetSpan(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const TermsPage(),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'terms and conditions',
                                                  style: TextStyle(
                                                    color: theme
                                                        .colorScheme.primary,
                                                    decoration: TextDecoration
                                                        .underline,
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
                                                child: Text(
                                                  'privacy policy',
                                                  style: TextStyle(
                                                    color: theme
                                                        .colorScheme.primary,
                                                    decoration: TextDecoration
                                                        .underline,
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
                                      backgroundColor:
                                          theme.colorScheme.primaryContainer,
                                      foregroundColor:
                                          theme.colorScheme.onPrimaryContainer,
                                      disabledBackgroundColor:
                                          theme.colorScheme.surfaceContainerLow,
                                      disabledForegroundColor:
                                          theme.colorScheme.onSurfaceVariant,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
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
                                    Text(
                                      'Already have an account? ',
                                      style: TextStyle(
                                          color: theme
                                              .colorScheme.onSurfaceVariant),
                                    ),
                                    GestureDetector(
                                      onTap: isLoading
                                          ? null
                                          : () {
                                              // GoRouter target parameter forwarding context values
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage(
                                                    fromGuest: widget.fromGuest,
                                                  ),
                                                ),
                                              );
                                            },
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
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
                      icon: Icon(
                        Icons.close,
                        size: 28,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: isLoading ? null : _handleCloseAction,
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
