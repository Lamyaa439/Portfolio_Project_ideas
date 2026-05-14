import '../../domain/entities/artist.dart';

abstract class ArtistProfileState {}

class ArtistProfileInitial extends ArtistProfileState {}

class ArtistProfileLoading extends ArtistProfileState {}

class ArtistProfileLoaded extends ArtistProfileState {
  final Artist artist;
  ArtistProfileLoaded(this.artist);
}

class ArtistProfileError extends ArtistProfileState {
  final String message;
  ArtistProfileError(this.message);
}
