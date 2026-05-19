import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loven/core/res/theme/app_colors.dart';
import 'package:loven/features/artist_profile/controller/view/screens/artist_profile_screen.dart';
import 'package:loven/features/home/View/Screens/home_screen.dart';
import 'package:loven/features/home/View/Screens/settings_screen.dart';
import '../../../../main.dart';
import '../../controller/cubit/navigation_bar_cubit.dart';
import '../widget/navigation_widget.dart';

class NavigationScreen extends StatelessWidget {
  final bool isGuest;

  const NavigationScreen({
    super.key,
    this.isGuest = false,
  });

  bool? get isDarkTheme => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/loven-logo.png',
          height: 40,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeBloc>().state == ThemeMode.light
                  ? Icons.nightlight_outlined
                  : Icons.light_mode_outlined,
            ),
            onPressed: () => context.read<ThemeBloc>().toggleTheme(),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      body: BlocBuilder<NavigationBarCubit, NavigationBarState>(
          builder: (context, state) {
        return IndexedStack(
          index: state.currentIndex,
          children: [
            HomeScreen(), // Assuming you have a HomeScreen defined
            SettingsScreen(),
            // here you can place page link to other pages
            // such as:
            // ArtistProfileScreen(),
            // CartScreen(),

            isGuest
                ? const Center(
                    child: Text('Guest Mode: Sign in to view profiles'))
                : const ArtistProfileScreen(artistId: 'test_artist_123'),

            isGuest
                ? const Center(
                    child: Text('Guest Mode: Sign in to view your cart'))
                : const Center(child: Text('Cart Content Coming Soon')),
          ],
        );
      }),
      bottomNavigationBar: const NavigationWidget(),
    );
  }
}
