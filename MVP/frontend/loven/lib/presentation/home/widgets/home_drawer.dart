import 'package:flutter/material.dart';

// A Drawer widget containing ListTiles for "My Orders" and "Settings".

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Text('LOVEN Menu',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('My Collection'),
            onTap: () {}, // Links to User's collection
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Orders'),
            onTap: () {}, // Links to Order class
          ),
        ],
      ),
    );
  }
}
