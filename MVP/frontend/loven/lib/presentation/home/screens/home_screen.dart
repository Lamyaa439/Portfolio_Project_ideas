import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../widgets/art_card.dart';
import '../widgets/home_drawer.dart'; // Add this import
import '../../../core/res/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Add the Drawer here
      drawer: const HomeDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // 2. Wrap leading in a Builder so the menu button works
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black26),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Image.asset('assets/images/loven-logo.png', height: 40),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.nightlight_outlined, color: Colors.black26),
            onPressed: () {}, // Theme toggle logic goes here
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
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to start
                children: [
                  const SizedBox(height: 20),

                  // --- Search bar ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: 'Search art, artists, categories...',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.tune, size: 20),
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- Categories ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryCard("Artists"),
                      _buildCategoryCard("Top Artworks"),
                      _buildCategoryCard("My Collection"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 3. --- The Swipeable Art Feed ---
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Text(
                      "Featured Art",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(
                    height: 320, // Give the horizontal list a fixed height
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

  Widget _buildCategoryCard(String title) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F0EF), // Using your brand off-white
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
