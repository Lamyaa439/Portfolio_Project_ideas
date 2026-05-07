import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/artist_profile_bloc.dart';
import '../bloc/artist_profile_event.dart';
import '../bloc/artist_profile_state.dart';
import '../widgets/artist_header.dart';
import '../widgets/artist_bio.dart';
import '../widgets/artist_stats.dart';
import '../widgets/artist_shipping_policy.dart';
import '../widgets/artworks_grid.dart';

class ArtistProfileScreen extends StatelessWidget {
  final String artistId;

  const ArtistProfileScreen({super.key, required this.artistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF7F2),
        elevation: 0,
        title: const Text(
          'LOVEN',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
      ),
      body: BlocBuilder<ArtistProfileBloc, ArtistProfileState>(
        builder: (context, state) {
          if (state is ArtistProfileLoading || state is ArtistProfileInitial) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFC2410C),
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
                      size: 60,
                      color: Color(0xFFC2410C),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'حدث خطأ',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B6B6B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ArtistProfileBloc>()
                            .add(GetArtistRequested(artistId));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('إعادة المحاولة'),
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
                  const SizedBox(height: 16),
                  ArtistHeader(artist: state.artist),
                  ArtistStats(artworksCount: 0),
                  ArtistBio(bio: state.artist.bio),
                  ArtistShippingPolicy(
                      shippingPolicy: state.artist.shippingPolicy),
                  const ArtworksGrid(),
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
