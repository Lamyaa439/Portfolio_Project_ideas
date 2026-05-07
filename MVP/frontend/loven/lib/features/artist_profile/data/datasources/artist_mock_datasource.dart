import '../models/artist_model.dart';
import 'artist_remote_datasource.dart';

class ArtistMockDataSource implements ArtistRemoteDataSource {
  @override
  Future<ArtistModel> getArtistById(String artistId) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(seconds: 1));

    return const ArtistModel(
      id: 'mock-id-123',
      userId: 'mock-user-456',
      displayName: 'سارة العتيبي',
      bio:
          'فنانة سعودية تستلهم أعمالها من الموروث الشعبي والصحراء. تعمل على لوحات زيتية تجمع بين التراث والحداثة، وتسعى لإيصال جمال الثقافة السعودية للعالم.',
      city: 'الرياض',
      profileImageUrl: null,
      shippingPolicy:
          'الشحن خلال 3-5 أيام عمل داخل المملكة. الشحن الدولي متاح حسب الطلب. جميع اللوحات مغلّفة بعناية لضمان وصولها سليمة.',
    );
  }
}
