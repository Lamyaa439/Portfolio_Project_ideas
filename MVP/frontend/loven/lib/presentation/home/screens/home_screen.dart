import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../widgets/art_card.dart';
import '../widgets/home_drawer.dart';
import '../../../main.dart';
import '../../auth/screens/signup_page.dart';

class HomeScreen extends StatelessWidget {
  final bool isGuest;

  const HomeScreen({super.key, this.isGuest = false});

  void _goToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: HomeDrawer(isGuest: isGuest),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: theme.colorScheme.primary,
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
              color: theme.colorScheme.primary,
            ),
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
                  const SizedBox(height: 16),
                  _buildSearchBar(theme),
                  const SizedBox(height: 10),
                  _buildCategories(state.categories),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Discover and Collect Art',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(
                    height: 350,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      itemCount: state.artPieces.length,
                      itemBuilder: (context, index) {
                        final art = state.artPieces[index];

                        // We removed the GestureDetector here because the
                        // updated ArtCard now handles its own onTap internally.
                        return ArtCard(
                          title: art['title'] ?? 'Untitled',
                          artistName: art['artistName'] ??
                              "Artist #${art['artist_id']}",
                          // Ensure price is a string for the UI
                          price: art['price']?.toString() ?? '0',
                          imageUrl: art['image_url'] ?? '',
                          // Pass the dynamic description from your backend/state
                          description: art['description'] ??
                              'Explore the story behind this unique piece of art.',
                          isGuest: isGuest,
                          onActionPressed: () {
                            if (isGuest) {
                              _goToSignup(context);
                            } else {
                              print("Action triggered for ${art['title']}");
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is HomeError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Start exploring art!'));
        },
      ),
    );
  }

  // --- Helper Methods ---

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search art, artists, categories...',
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.tune,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            suffixIcon: Icon(Icons.search,
                color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(List<String> categories) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildCategoryCard(context, categories[index]),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
