import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/artist_profile_bloc.dart';
import '../bloc/artist_profile_event.dart';
=======
>>>>>>> 9a667a187fa857595d8ce0d9e597a4dfe3853939
import '../bloc/artist_profile_state.dart';
import '../widgets/artist_header.dart';
import '../widgets/artist_bio.dart';
import '../widgets/artist_shipping_policy.dart';
import '../widgets/artworks_grid.dart';

class ArtistProfileScreen extends StatelessWidget {
  final String artistId;

  const ArtistProfileScreen({super.key, required this.artistId});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'حسابي',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
        ),
        body: BlocBuilder<ArtistProfileBloc, ArtistProfileState>(
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
                        'حدث خطأ',
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
                    ArtistHeader(artist: state.artist),
                    ArtistBio(bio: state.artist.bio),
                    ArtistShippingPolicy(
                      shippingPolicy: state.artist.shippingPolicy,
                    ),
                    ArtworksGrid(artworks: state.artist.artworks),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
        // body: BlocBuilder<ArtistProfileCubit, ArtistProfileState>(
        // builder: (context, state) {
        //   if (state is ArtistProfileLoading ||
        //       state is ArtistProfileInitial) {
        //     return const Center(
        //       child: CircularProgressIndicator(
        //         color: Color(0xFF8B7AB8),
        //       ),
        //     );
        //   }

        //   if (state is ArtistProfileError) {
        //     return Center(
        //       child: Padding(
        //         padding: const EdgeInsets.all(24),
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             const Icon(
        //               Icons.error_outline,
        //               size: 50,
        //               color: Color(0xFF8E8E93),
        //             ),
        //             const SizedBox(height: 12),
        //             const Text(
        //               'حدث خطأ',
        //               style: TextStyle(
        //                 fontSize: 16,
        //                 fontWeight: FontWeight.w600,
        //               ),
        //             ),
        //             const SizedBox(height: 8),
        //             Text(
        //               state.message,
        //               textAlign: TextAlign.center,
        //               style: const TextStyle(
        //                 fontSize: 13,
        //                 color: Color(0xFF8E8E93),
        //               ),
        //             ),
        //             const SizedBox(height: 16),
        //             ElevatedButton(
        //               onPressed: () {
        //                 context
        //                     .read<ArtistProfileCubit>()
        //                     .getArtist(artistId);
        //               },
        //               style: ElevatedButton.styleFrom(
        //                 backgroundColor: const Color(0xFF1A1A1A),
        //                 foregroundColor: Colors.white,
        //               ),
        //               child: const Text('إعادة المحاولة'),
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //   }

        //   if (state is ArtistProfileLoaded) {
        //     return SingleChildScrollView(
        //       child: Column(
        //         children: [
        //           ArtistHeader(artist: state.artist),
        //           ArtistBio(bio: state.artist.bio),
        //           ArtistShippingPolicy(
        //             shippingPolicy: state.artist.shippingPolicy,
        //           ),
        //           ArtworksGrid(artworks: state.artist.artworks),
        //           const SizedBox(height: 24),
        //         ],
        //       ),
        //     );
        //   }

        //   return const SizedBox.shrink();
        // },
      ),
    );
  }
}
