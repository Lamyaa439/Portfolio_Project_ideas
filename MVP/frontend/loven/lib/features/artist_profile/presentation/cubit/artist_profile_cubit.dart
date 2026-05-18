import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loven/features/artist_profile/data/datasources/artist_profile_remote_datasource.dart';
import 'artist_profile_state.dart';

class ArtistProfileCubit extends Cubit<ArtistProfileState> {
  final ArtistProfileRemoteDataSource _remoteDataSource;

  ArtistProfileCubit(this._remoteDataSource) : super(ArtistProfileInitial());

  Future<void> createProfile({
    required String displayName,
    String? city,
    String? bio,
    String? shippingPolicy,
    String? profileImageUrl,
  }) async {
    emit(ArtistProfileLoading());

    try {
      final profile = await _remoteDataSource.createProfile(
        displayName: displayName,
        city: city,
        bio: bio,
        shippingPolicy: shippingPolicy,
        profileImageUrl: profileImageUrl,
      );

      emit(ArtistProfileLoaded(profile));
    } catch (e) {
      emit(ArtistProfileError(e.toString()));
    }
  }

  Future<void> getMyProfile() async {
    emit(ArtistProfileLoading());

    try {
      final profile = await _remoteDataSource.getMyProfile();

      emit(ArtistProfileLoaded(profile));
    } catch (e) {
      emit(ArtistProfileError(e.toString()));
    }
  }

  Future<void> updateMyProfile({
    String? displayName,
    String? city,
    String? bio,
    String? shippingPolicy,
    String? profileImageUrl,
  }) async {
    emit(ArtistProfileLoading());

    try {
      final profile = await _remoteDataSource.updateMyProfile(
        displayName: displayName,
        city: city,
        bio: bio,
        shippingPolicy: shippingPolicy,
        profileImageUrl: profileImageUrl,
      );

      emit(ArtistProfileLoaded(profile));
    } catch (e) {
      emit(ArtistProfileError(e.toString()));
    }
  }

  Future<void> deleteMyProfile() async {
    emit(ArtistProfileLoading());

    try {
      await _remoteDataSource.deleteMyProfile();

      emit(
        ArtistProfileSuccess(
          'Artist profile deleted successfully',
        ),
      );
    } catch (e) {
      emit(ArtistProfileError(e.toString()));
    }
  }

  Future<void> listProfiles({
    int limit = 20,
    int offset = 0,
  }) async {
    emit(ArtistProfileLoading());

    try {
      final data = await _remoteDataSource.listProfiles(
        limit: limit,
        offset: offset,
      );

      emit(
        ArtistProfilesLoaded(
          data['profiles'] ?? [],
        ),
      );
    } catch (e) {
      emit(ArtistProfileError(e.toString()));
    }
  }

  Future<void> getProfileById({
    required String profileId,
  }) async {
    emit(ArtistProfileLoading());

    try {
      final profile = await _remoteDataSource.getProfileById(
        profileId: profileId,
      );

      emit(ArtistProfileLoaded(profile));
    } catch (e) {
      emit(ArtistProfileError(e.toString()));
    }
  }

  Future<void> getProfileByDisplayName({
    required String displayName,
  }) async {
    emit(ArtistProfileLoading());

    try {
      final profile = await _remoteDataSource.getProfileByDisplayName(
        displayName: displayName,
      );

      emit(ArtistProfileLoaded(profile));
    } catch (e) {
      emit(ArtistProfileError(e.toString()));
    }
  }

  Future<void> listProfileArtworks({
    required String profileId,
    int limit = 20,
    int offset = 0,
    String status = 'available',
  }) async {
    emit(ArtistProfileLoading());

    try {
      final data = await _remoteDataSource.listProfileArtworks(
        profileId: profileId,
        limit: limit,
        offset: offset,
        status: status,
      );

      emit(
        ArtistProfileArtworksLoaded(
          data['artworks'] ?? [],
        ),
      );
    } catch (e) {
      emit(ArtistProfileError(e.toString()));
    }
  }
}
