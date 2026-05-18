import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/artist_profile_cubit.dart';
import '../cubit/artist_profile_state.dart';
import '../widgets/artist_header.dart';
import '../widgets/artist_bio.dart';
import '../widgets/artist_shipping_policy.dart';
import '../widgets/artworks_grid.dart';

class ArtistProfileScreen extends StatefulWidget {
  const ArtistProfileScreen({super.key});

  @override
  State<ArtistProfileScreen> createState() =>
      _ArtistProfileScreenState();
}

class _ArtistProfileScreenState
    extends State<ArtistProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ArtistProfileCubit>().getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFF1A1A1A),
        ),
      ),
      body: BlocBuilder<ArtistProfileCubit, ArtistProfileState>(
        builder: (context, state) {
          if (state is ArtistProfileLoading ||
              state is ArtistProfileInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8B7AB8),
              ),
            );
          }

          if (state is ArtistProfileError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Color(0xFF8E8E93),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ArtistProfileCubit>()
                            .getMyProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ArtistProfileLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ArtistHeader(artist: state.artist),
                  ArtistBio(bio: state.artist.bio),
                  ArtistShippingPolicy(
                    shippingPolicy: state.artist.shippingPolicy,
                  ),
                  ArtworksGrid(
                    artworks: state.artist.artworks,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}