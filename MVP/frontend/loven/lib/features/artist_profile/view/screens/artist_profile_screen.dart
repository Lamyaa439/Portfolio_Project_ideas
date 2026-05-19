import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/res/theme/app_colors.dart';
import '../../controller/artist_profile_cubit.dart';
import '../../controller/artist_profile_state.dart';
import '../../model/artist_repository.dart';
import '../widgets/artist_header_widget.dart';
import '../widgets/artwork_grid_widget.dart';

/// Logged-in artist profile screen — uses global [ThemeData] from [AppTheme].
class ArtistProfileScreen extends StatelessWidget {
  const ArtistProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArtistProfileCubit(
        repository: ArtistRepository(),
      )..fetchMyProfileData(),
      child: const _ArtistProfileBody(),
    );
  }
}

class _ArtistProfileBody extends StatelessWidget {
  const _ArtistProfileBody();

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
          'My Profile',
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
                return _SuccessContent(state: state);
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
                  onRetry: () => context
                      .read<ArtistProfileCubit>()
                      .fetchMyProfileData(),
                );
              }
              return _SuccessContent(state: state);

            case ArtistProfileStatus.success:
              return _SuccessContent(state: state);
          }
        },
      ),
    );
  }
}

class _SuccessContent extends StatelessWidget {
  const _SuccessContent({required this.state});

  final ArtistProfileState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final artist = state.artist!;

    return RefreshIndicator(
      color: AppColors.deepPurple,
      onRefresh: () =>
          context.read<ArtistProfileCubit>().fetchMyProfileData(),
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
                'My Artworks',
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
