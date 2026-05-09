import 'package:flutter/material.dart';
import '../../../core/storage/token_storage.dart';
import '../../splash/splash_screen.dart';
import '../screens/home_screen.dart'; // Fixed path
import '../../auth/screens/login_page.dart'; // Fixed path
import '../../auth/screens/signup_page.dart'; // Fixed path

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  Future<void> _logout(BuildContext context) async {
    await TokenStorage().clearToken();
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF303FAD)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'LOVEN Menu',
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('My Collection'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Orders'),
            onTap: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title:
                const Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onTap: () => _logout(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
