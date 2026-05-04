import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../widgets/art_card.dart';
import '../widgets/home_drawer.dart';
// Import your main.dart or core theme file to access ThemeBloc
import '../../../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme to use its colors for non-Material widgets
    final theme = Theme.of(context);

    return Scaffold(
      // Dynamic background color based on theme
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const HomeDrawer(),
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            // Adapts icon color to theme
            icon: Icon(Icons.menu,
                color: theme.colorScheme.onSurface.withOpacity(0.3)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Image.asset('assets/images/loven-logo.png', height: 40),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              // Toggle icon based on current state
              context.watch<ThemeBloc>().state == ThemeMode.light
                  ? Icons.nightlight_outlined
                  : Icons.light_mode_outlined,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            // This triggers the switch you set up in main.dart
            onPressed: () => context.read<ThemeBloc>().toggleTheme(),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // --- Search bar ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        // Uses 'surface' color which changes in Dark Mode
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        textAlign: TextAlign.right,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: 'Search art, artists, categories...',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5)),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.tune,
                              size: 20, color: theme.colorScheme.primary),
                          suffixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- Categories (Fixed for image_62ce47.png) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryCard(context, "Artists"),
                      _buildCategoryCard(context, "Top Artworks"),
                      _buildCategoryCard(context, "My Collection"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- The Swipeable Art Feed ---
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Text(
                      "Featured Art",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 320,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 20),
                      children: const [
                        ArtCard(
                          title: "Sunset over Riyadh",
                          price: "1,200",
                          imageUrl: "assets/images/art1.jpg",
                        ),
                        ArtCard(
                          title: "Modern Calligraphy",
                          price: "850",
                          imageUrl: "assets/images/art2.jpg",
                        ),
                        ArtCard(
                          title: "Desert Silence",
                          price: "2,100",
                          imageUrl: "assets/images/art3.jpg",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          } else if (state is HomeError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Start exploring art!'));
        },
      ),
    );
  }

  // Updated Helper method to use Context-based Theme
  Widget _buildCategoryCard(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        // Dynamic color: Light = Off-white, Dark = Dark Grey/Surface
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color:
                  theme.colorScheme.onSurface, // Text flips color automatically
            ),
          ),
        ),
      ),
    );
  }
}
