import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/res/theme/app_colors.dart';
import '../../controller/artist_profile_cubit.dart';
import '../../controller/artist_profile_state.dart';
import '../../model/artist_repository.dart';
import '../widgets/artist_header_widget.dart';
import '../widgets/artwork_grid_widget.dart';

/// Artist profile screen — uses global [ThemeData] from [AppTheme].
///
/// When [artistProfileId] is null, loads the logged-in artist (`/my-profile`).
/// When set, loads a public profile (`/artist/:artistId`).
class ArtistProfileScreen extends StatelessWidget {
  const ArtistProfileScreen({
    super.key,
    this.artistProfileId,
  });

  /// `null` → own profile; non-null → public profile UUID from GoRouter.
  final String? artistProfileId;

  bool get _isPublicView => artistProfileId != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ArtistProfileCubit(repository: ArtistRepository());
        if (_isPublicView) {
          cubit.fetchPublicArtistProfile(artistProfileId!);
        } else {
          cubit.fetchMyProfileData();
        }
        return cubit;
      },
      child: _ArtistProfileBody(
        isPublicView: _isPublicView,
        artistProfileId: artistProfileId,
      ),
    );
  }
}

class _ArtistProfileBody extends StatelessWidget {
  const _ArtistProfileBody({
    required this.isPublicView,
    this.artistProfileId,
  });

  final bool isPublicView;
  final String? artistProfileId;

  /// Returns a [Future] so [RefreshIndicator.onRefresh] can await the reload.
  Future<void> _reload(ArtistProfileCubit cubit) {
    if (isPublicView && artistProfileId != null) {
      return cubit.fetchPublicArtistProfile(artistProfileId!);
    }
    return cubit.fetchMyProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          isPublicView ? 'Artist Profile' : 'My Profile',
          style: theme.textTheme.titleMedium,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      body: BlocConsumer<ArtistProfileCubit, ArtistProfileState>(
        // SnackBar for background failures (e.g. PATCH) when data stays on screen.
        listenWhen: (previous, current) =>
            current.status == ArtistProfileStatus.error &&
            current.errorMessage != null &&
            current.artist != null,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Something went wrong'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: colorScheme.primary,
              ),
            );
        },
        builder: (context, state) {
          switch (state.status) {
            case ArtistProfileStatus.initial:
            case ArtistProfileStatus.loading:
              if (state.artist != null) {
                return _SuccessContent(
                  state: state,
                  isPublicView: isPublicView,
                  onRefresh: () => _reload(context.read<ArtistProfileCubit>()),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ),
              );

            case ArtistProfileStatus.error:
              if (state.artist == null) {
                return _ErrorView(
                  message: state.errorMessage ?? 'An unexpected error occurred',
                  onRetry: () => _reload(context.read<ArtistProfileCubit>()),
                );
              }
              return _SuccessContent(
                state: state,
                isPublicView: isPublicView,
                onRefresh: () => _reload(context.read<ArtistProfileCubit>()),
              );

            case ArtistProfileStatus.success:
              return _SuccessContent(
                state: state,
                isPublicView: isPublicView,
                onRefresh: () => _reload(context.read<ArtistProfileCubit>()),
              );
          }
        },
      ),
    );
  }
}

class _SuccessContent extends StatelessWidget {
  const _SuccessContent({
    required this.state,
    required this.isPublicView,
    required this.onRefresh,
  });

  final ArtistProfileState state;
  final bool isPublicView;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final artist = state.artist!;

    return RefreshIndicator(
      color: AppColors.deepPurple,
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ArtistHeaderWidget(artist: artist),
          ),
          SliverToBoxAdapter(
            child: Divider(
              height: 1,
              color: theme.dividerColor,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                isPublicView ? 'Artworks' : 'My Artworks',
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ArtworkGridWidget(artworks: state.artworks),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: colorScheme.onSurface.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 12),
            Text(
              'Could not load profile',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            // Uses [AppTheme] elevatedButtonTheme — no custom color overrides.
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
