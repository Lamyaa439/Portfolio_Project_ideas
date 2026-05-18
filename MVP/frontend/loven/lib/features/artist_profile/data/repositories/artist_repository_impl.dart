import '../../domain/entities/artist.dart';
import '../../domain/repositories/artist_repository.dart';
import '../datasources/artist_remote_datasource.dart';
import '../../../../core/storage/token_storage.dart';

/// **Artist Repository Implementation**
/// 
/// This acts as the bridge. The Domain layer requests data via the Interface, 
/// and this file dictates where to fetch it from (e.g., the API via RemoteDataSource).

class ArtistRepositoryImpl implements ArtistRepository {
  final ArtistRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage; 

  ArtistRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
    });

  // تجيب بروفايل اي فنان لنعرضه للمستخدم
  @override
  Future<Artist> getArtistById(String artistId) async {
    return await remoteDataSource.getArtistById(artistId);
  }

  // تجيب بيانات الفنان نفسه
  @override
  Future<Artist> getMyProfile() async {
    final String? token = await tokenStorage.getToken();
    if (token == null) {
      throw Exception('Unauthorized: No token found. Please login.');
    }

    return await remoteDataSource.getMyProfile(token);
  }

  // ترسل تحديث بيانات الفنان إذا عدلها
  @override
  Future<Artist> updateMyProfile({
    String? bio,
    String? city,
    String? shippingPolicy,
  }) async {
    // نتحقق من الصلاحيات 
    final String? token = await tokenStorage.getToken();

    if (token == null) {
      throw Exception('Unauthorized: No token found. Please login.');
    }

    return await remoteDataSource.updateMyProfile(
      token,
      bio: bio,
      city: city,
      shippingPolicy: shippingPolicy,
      );
  }
}
