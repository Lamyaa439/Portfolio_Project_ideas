import 'package:loven/features/artist_profile/data/models/artist_model.dart';

abstract class ArtistProfileState {}

class ArtistProfileInitial extends ArtistProfileState {}

class ArtistProfileLoading extends ArtistProfileState {}

class ArtistProfileLoaded extends ArtistProfileState {
  final ArtistModel artist;

  ArtistProfileLoaded(this.artist);
}

class ArtistProfileSuccess extends ArtistProfileState {
  final String message;

  ArtistProfileSuccess(this.message);
}

class ArtistProfileError extends ArtistProfileState {
  final String message;

  ArtistProfileError(this.message);
}