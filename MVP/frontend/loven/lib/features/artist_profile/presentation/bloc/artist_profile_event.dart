abstract class ArtistProfileEvent {}

class GetArtistRequested extends ArtistProfileEvent {
  final String artistId;

  GetArtistRequested(this.artistId);
}

class GetMyArtistProfileRequested extends ArtistProfileEvent {}
