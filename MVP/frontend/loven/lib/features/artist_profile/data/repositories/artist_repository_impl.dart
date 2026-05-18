import '../../domain/entities/artist.dart';
import '../../domain/repositories/artist_repository.dart';
import '../datasources/artist_remote_datasource.dart';

/// **Artist Repository Implementation**
/// 
/// This acts as the bridge. The Domain layer requests data via the Interface, 
/// and this file dictates where to fetch it from (e.g., the API via RemoteDataSource).

class ArtistRepositoryImpl implements ArtistRepository {
  final ArtistRemoteDataSource remoteDataSource;

  ArtistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Artist> getArtistById(String artistId) async {
    return await remoteDataSource.getArtistById(artistId);
  }
}
