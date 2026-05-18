import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loven/features/artist_profile/data/repositories/artist_repository.dart';
import 'artist_profile_state.dart';

class ArtistProfileCubit extends Cubit<ArtistProfileState> {
  final ArtistRepository _repository;

  ArtistProfileCubit(this._repository) : super(ArtistProfileInitial());

  Future<void> getArtistById(String artistId) async {
    emit(ArtistProfileLoading());

    try {
      final artist = await _repository.getArtistById(artistId);
      emit(ArtistProfileLoaded(artist));
    } catch (e) {
      emit(ArtistProfileError(e.toString()));
    }
  }

  Future<void> getMyProfile() async {
    emit(ArtistProfileLoading());

    try {
      final artist = await _repository.getMyProfile();
      emit(ArtistProfileLoaded(artist));
    } catch (e) {
      emit(ArtistProfileError(e.toString()));
    }
  }

  Future<void> updateMyProfile({
    String? bio,
    String? city,
    String? shippingPolicy,
  }) async {
    emit(ArtistProfileLoading());

    try {
      final artist = await _repository.updateMyProfile(
        bio: bio,
        city: city,
        shippingPolicy: shippingPolicy,
      );

      emit(ArtistProfileLoaded(artist));
    } catch (e) {
      emit(ArtistProfileError(e.toString()));
    }
  }
}