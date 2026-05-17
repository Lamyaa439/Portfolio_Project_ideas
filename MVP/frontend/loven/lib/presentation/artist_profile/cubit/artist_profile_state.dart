abstract class ArtistProfileState {}

class ArtistProfileInitial extends ArtistProfileState {}

class ArtistProfileLoading extends ArtistProfileState {}

class ArtistProfileLoaded extends ArtistProfileState {
  final Map<String, dynamic> profile;

  ArtistProfileLoaded(this.profile);
}

class ArtistProfilesLoaded extends ArtistProfileState {
  final List<dynamic> profiles;

  ArtistProfilesLoaded(this.profiles);
}

class ArtistProfileArtworksLoaded extends ArtistProfileState {
  final List<dynamic> artworks;

  ArtistProfileArtworksLoaded(this.artworks);
}

class ArtistProfileSuccess extends ArtistProfileState {
  final String message;

  ArtistProfileSuccess(this.message);
}

class ArtistProfileError extends ArtistProfileState {
  final String message;

  ArtistProfileError(this.message);
}
