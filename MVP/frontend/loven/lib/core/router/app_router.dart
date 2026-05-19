import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loven/features/artist_profile/view/screens/artist_profile_screen.dart';
import 'package:loven/features/auth/view/screens/signup_page.dart';
import 'package:loven/features/navigation/view/Screens/navigation_screen.dart';
import 'package:loven/features/splash/splash_screen.dart';

bool isUserBrowsingAsGuest = true;

final GoRouter router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    if (isUserBrowsingAsGuest) {
      final checkingOut = state.matchedLocation.startsWith('/cart');
      final viewingProfile = state.matchedLocation.startsWith('/profile') ||
          state.matchedLocation.startsWith('/my-profile') ||
          state.matchedLocation.startsWith('/artist/');
      final interactingWithArt =
          state.matchedLocation.startsWith('/art-details');

      if (checkingOut || viewingProfile || interactingWithArt) {
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
      path: '/splash_screen',
      builder: (context, state) => const SplashScreen(),
    ),
    // Logged-in artist dashboard (JWT — loads GET /artist-profiles/me).
    GoRoute(
      path: '/my-profile',
      builder: (context, state) => const ArtistProfileScreen(),
    ),
    // Alias kept for bottom-nav / legacy links.
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ArtistProfileScreen(),
    ),
    // Public storefront profile (no JWT — GET /artist-profiles/:id).
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
      path: '/art-details',
      builder: (context, state) =>
          const Center(child: Text('Art Details Protected Page')),
    ),
  ],
);
