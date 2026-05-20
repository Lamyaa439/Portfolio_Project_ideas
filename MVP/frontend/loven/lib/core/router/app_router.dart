import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:loven/features/auth/view/screens/login_page.dart';
import 'package:loven/features/artist_profile/model/artist_model.dart';
import 'package:loven/features/artwork/view/screens/create_artwork_screen.dart';
import 'package:loven/features/splash/splash_screen.dart';
import 'package:loven/features/home/View/art_details_screen.dart';
import 'package:loven/features/auth/view/screens/signup_page.dart';
import 'package:loven/features/navigation/view/screens/navigation_screen.dart';
import 'package:loven/features/artist_profile/view/screens/artist_profile_screen.dart';

bool isUserBrowsingAsGuest = true;

final GoRouter router = GoRouter(
  initialLocation: '/splash_screen',
  redirect: (context, state) {
    if (isUserBrowsingAsGuest) {
      final checkingOut = state.matchedLocation.startsWith('/cart');

      final viewingProfile = state.matchedLocation.startsWith('/profile') ||
          state.matchedLocation.startsWith('/my-profile') ||
          state.matchedLocation.startsWith('/artist/');

      final interactingWithArt =
          state.matchedLocation.startsWith('/art-details');

      final creatingArtwork =
          state.matchedLocation.startsWith('/artworks/create');

      if (checkingOut ||
          viewingProfile ||
          interactingWithArt ||
          creatingArtwork) {
        return '/auth';
      }
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          NavigationScreen(isGuest: isUserBrowsingAsGuest),
    ),

    GoRoute(
      path: '/auth',
      builder: (context, state) => const SignupPage(),
    ),
    
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(fromGuest: true),
    ),

    GoRoute(
      path: '/splash_screen',
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: '/my-profile',
      builder: (context, state) => const ArtistProfileScreen(),
    ),

    GoRoute(
      path: '/profile',
      builder: (context, state) => const ArtistProfileScreen(),
    ),

    GoRoute(
      path: '/artist/:artistId',
      builder: (context, state) {
        final artistId = state.pathParameters['artistId']!;
        return ArtistProfileScreen(artistProfileId: artistId);
      },
    ),

    GoRoute(
      path: '/cart',
      builder: (context, state) => const SizedBox.shrink(),
    ),

    GoRoute(
      path: '/artworks/create',
      builder: (context, state) => const CreateArtworkScreen(),
    ),

    GoRoute(
      path: '/art-details',
      builder: (context, state) {
        final artItem = state.extra as ArtworkModel;

        return ArtDetailsScreen(
          artItem: artItem,
        );
      },
    ),
  ],
);