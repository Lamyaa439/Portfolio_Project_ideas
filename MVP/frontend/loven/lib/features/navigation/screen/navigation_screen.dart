import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loven/core/res/theme/app_colors.dart';
import 'package:loven/features/artist_profile/presentation/screens/artist_profile_screen.dart';
import 'package:loven/presentation/home/screens/home_screen.dart';
import 'package:loven/presentation/home/screens/settings_screen.dart';
import '../../../main.dart';
import '../cubit/navigation_bar_cubit.dart';
import '../widget/navigation_widget.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({
    super.key,
  });

  bool? get isDarkTheme => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: AppColors.primaryBlue,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
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
              color: AppColors.primaryBlue,
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
            ArtistProfileScreen(),
          ],
        );
      }),
      bottomNavigationBar: const NavigationWidget(),
    );
  }
}
