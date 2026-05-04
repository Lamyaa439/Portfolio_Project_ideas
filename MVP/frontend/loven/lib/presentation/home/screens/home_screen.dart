import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black26),
        title:
            Image.asset('assets/images/LOVEN_logo.png', height: 40), //logo here
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.nightlight_outlined, color: Colors.black26),
            onPressed: () {},
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
                children: [
                  const SizedBox(height: 20),

                  // 1. Search bar - Fixed Container/Padding nesting
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const TextField(
                        textAlign: TextAlign.right, // Support for Arabic design
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

                  // 2. Categories
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryCard("Artists"),
                      _buildCategoryCard("Top Artworks"),
                      _buildCategoryCard("My Collection"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 3. Art Card placeholder
                  const Text("Art card will go here..."),
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

  // 4. Helper method for Category Cards
  Widget _buildCategoryCard(String title) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[100],
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
