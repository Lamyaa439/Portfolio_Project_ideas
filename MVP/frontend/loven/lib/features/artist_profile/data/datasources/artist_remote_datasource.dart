import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/artist_model.dart';
 
/// Handles direct HTTP communication with the Flask Backend.

/// **Artist Remote Data Source Interface**
abstract class ArtistRemoteDataSource {
  // يستعرض بروفايل الفنان للمستخدمين
  Future<ArtistModel> getArtistById(String artistId);

  // يستعرض الفنان بروفايله
  Future<ArtistModel> getMyProfile(String token);

  // تحديث بيانات الفنان الحالي
  Future<ArtistModel> updateMyProfile(
    String token,
    { String? bio, 
    String? city,
    String? shippingPolicy}
  );
}

/// **Artist Remote Data Source Implementation**
class ArtistRemoteDataSourceImpl implements ArtistRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ArtistRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  // هذي الدالة لاستعراض بروفايل الفنانين للزائرين أو المستخدمين
  @override
  Future<ArtistModel> getArtistById(String artistId) async {
    final response = await client.get(
      // Uniform Resource Identifier
      Uri.parse('$baseUrl/artists/$artistId'),
      headers: {'Content-Type': 'application/json'}, // الزائر لا يحتاج توكن
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return ArtistModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load artist: ${response.statusCode}');
    }
  }

  // هذي الدالة للفنان نفسه لما يبي يستعرض حسابه
  @override
  Future<ArtistModel> getMyProfile(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/artist-profiles/me'),
      // نمرر التوكن للسيرفر ليفحصه ويتأكد من صاحب الطلب 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // تمرير التوكن إجباري هنا
      },
    );

    // حالة النجاح
    if (response.statusCode == 200) {
      // fromjson ونمرره لدالة Map لتحويله إلى  decode ونفك التشفير JSON نأخذ 
      return ArtistModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) { // حالة الفشل إذا كان التوكن منتهي
      throw Exception('Unauthorized: Session expired or invalid token');
    } else { // أخطاء أخرى
      throw Exception('Failed to load my profile: ${response.statusCode}');
    }
  }

  // هذي الدالة للفنان نفسه لما يبي يعدل معلومات في بروفايله
  @override
  Future<ArtistModel> updateMyProfile(String token, 
  {String? bio,
   String? city,
   String? shippingPolicy}) async {
    // فارغ عشان نحط فيها البيانات اللي غيرها الفنان Map ننشئ 
    final Map<String, dynamic> requestBody = {};
    // نتأكد وش الحقول اللي غيرها عشان نرسلها، اللي مايغيره نتجاهله
    // عشان نخفف من حجم البيانات المرسلة
    if (bio != null) requestBody['bio'] = bio;
    if (city != null) requestBody['city'] = city;
    if (shippingPolicy != null) requestBody['shipping_policy'] = shippingPolicy;

    final response = await client.patch( //لأنه تعديل جزئي PATCH استخدمنا
      // إرسال الطلب 
      Uri.parse('$baseUrl/artists/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // نرفق التوكن
      },
      body: json.encode(requestBody), //عشان يفهمه السيرفر JSON إلى  Mapتحويل ال 
    );

    if (response.statusCode == 200) {
      return ArtistModel.fromJson(json.decode(response.body)); // إرجاع النسخة المحدثة
    } else {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }
}
