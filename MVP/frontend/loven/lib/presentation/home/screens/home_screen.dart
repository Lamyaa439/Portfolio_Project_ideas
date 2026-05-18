import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../bloc/home_event.dart';
import '../widgets/art_card.dart';
import '../widgets/home_drawer.dart';

class HomeScreen extends StatelessWidget {
  final bool isGuest;

  const HomeScreen({super.key, this.isGuest = false});

  void _goToSignup(BuildContext context) {
    context.push('/signup?fromGuest=true');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: HomeDrawer(isGuest: isGuest),
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
                  _buildSearchBar(theme, context), // Pass Context
                  const SizedBox(height: 10),
                  _buildCategories(context, state.categories,
                      state.selectedCategory), // Pass Active selection
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Discover and Collect Art',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(
                    height: 350,
                    child: state.artPieces.isEmpty
                        ? const Center(
                            child: Text("No pieces found matching filters."))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 16),
                            itemCount: state.artPieces.length,
                            itemBuilder: (context, index) {
                              final art = state.artPieces[index];

                              return ArtCard(
                                title: art['title'] ?? 'Untitled',
                                artistName: art['artistName'] ??
                                    "Artist #${art['artist_id']}",
                                price: art['price']?.toString() ?? '0',
                                imageUrl: art['image_url'] ?? '',
                                description: art['description'] ??
                                    'Explore the story behind this unique piece of art.',
                                isGuest: isGuest,
                                onActionPressed: () {
                                  if (isGuest) {
                                    _goToSignup(context);
                                  } else {
                                    print(
                                        "Action triggered for ${art['title']}");
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

  Widget _buildSearchBar(ThemeData theme, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          onChanged: (text) {
            context.read<HomeBloc>().add(FilterArtworks(searchText: text));
          },
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

  Widget _buildCategories(
      BuildContext context, List<String> categories, String selectedCategory) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final categoryName = categories[index];
          final isSelected = categoryName == selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _buildCategoryCard(context, categoryName, isSelected),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String title, bool isSelected) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        context.read<HomeBloc>().add(FilterArtworks(category: title));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.secondary
              : theme.colorScheme.secondary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: isSelected
                  ? theme.colorScheme.onSecondary
                  : theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
