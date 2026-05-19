import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/artist_repository.dart';
import 'artist_profile_event.dart';
import 'artist_profile_state.dart';

class ArtistProfileBloc extends Bloc<ArtistProfileEvent, ArtistProfileState> {
  final ArtistRepository repository;

  ArtistProfileBloc({required this.repository})
      : super(ArtistProfileInitial()) {
    on<GetArtistRequested>(_onGetArtistRequested);
    on<GetMyArtistProfileRequested>(_onGetMyArtistProfileRequested);
  }

  Future<void> _onGetArtistRequested(
    GetArtistRequested event,
    Emitter<ArtistProfileState> emit,
  ) async {
    emit(ArtistProfileLoading());
    try {
      final artist = await repository.getArtistById(event.artistId);
      emit(ArtistProfileLoaded(artist));
    } catch (e) {
      emit(ArtistProfileError(e.toString()));
    }
  }

  Future<void> _onGetMyArtistProfileRequested(
    GetMyArtistProfileRequested event,
    Emitter<ArtistProfileState> emit,
  ) async {
    emit(ArtistProfileLoading());
    try {
      final artist = await repository.getMyArtistProfile();
      emit(ArtistProfileLoaded(artist));
    } catch (e) {
      emit(ArtistProfileError(e.toString()));
    }
  }
}
