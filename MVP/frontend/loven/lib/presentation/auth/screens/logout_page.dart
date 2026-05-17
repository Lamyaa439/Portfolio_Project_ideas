import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../../../core/storage/token_storage.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  // Future<void> _logout(BuildContext context) async {
  //   await TokenStorage().clearToken();

  //   if (!context.mounted) return;

  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const WelcomeScreen(),
  //     ),
  //     (route) => false,
  //   );
  // }

  void _handleLogout(BuildContext context) {
    context.read<AuthCubit>().logout();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      title: Text(
        'Log out',
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        'Are you sure you want to log out?',
        style: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        TextButton(
          onPressed: () => _handleLogout(context),
          child: Text(
            'Log out',
            style: TextStyle(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
