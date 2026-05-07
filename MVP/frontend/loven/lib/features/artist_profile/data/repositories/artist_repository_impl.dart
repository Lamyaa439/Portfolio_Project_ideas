import '../../domain/entities/artist.dart';
import '../../domain/repositories/artist_repository.dart';
import '../datasources/artist_remote_datasource.dart';

class ArtistRepositoryImpl implements ArtistRepository {
  final ArtistRemoteDataSource remoteDataSource;

  ArtistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Artist> getArtistById(String artistId) async {
    return await remoteDataSource.getArtistById(artistId);
  }
}
