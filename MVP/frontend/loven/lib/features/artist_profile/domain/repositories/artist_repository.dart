import '../entities/artist.dart';

abstract class ArtistRepository {
  Future<Artist> getArtistById(String artistId);
  Future<Artist> getMyArtistProfile();
}
