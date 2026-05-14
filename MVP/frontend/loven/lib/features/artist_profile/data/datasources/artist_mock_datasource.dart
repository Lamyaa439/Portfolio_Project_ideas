import '../../domain/entities/artwork.dart';
import '../models/artist_model.dart';
import 'artist_remote_datasource.dart';

class ArtistMockDataSource implements ArtistRemoteDataSource {
  @override
  Future<ArtistModel> getArtistById(String artistId) async {
    await Future.delayed(const Duration(seconds: 1));

    return const ArtistModel(
      id: 'mock-id-123',
      userId: 'mock-user-456',
      displayName: 'أروى محمد',
      city: 'الرياض',
      bio:
          'فنانة سعودية تستلهم أعمالها من الموروث الشعبي والصحراء. تجمع بين التراث والحداثة في لوحاتها.',
      profileImageUrl: null,
      shippingPolicy:
          'الشحن خلال 3-5 أيام عمل داخل المملكة. جميع اللوحات مغلّفة بعناية لضمان وصولها سليمة.',
      artworks: [
        Artwork(id: 'art-1', title: 'لوحة الصحراء', price: 1500),
        Artwork(id: 'art-2', title: 'ألوان الغروب', price: 2200),
        Artwork(id: 'art-3', title: 'الموروث', price: 1800),
        Artwork(id: 'art-4', title: 'حنين', price: 2500),
      ],
    );
  }
}
