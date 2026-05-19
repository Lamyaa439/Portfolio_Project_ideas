import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/storage/token_storage.dart';
import '../models/artist_model.dart';

abstract class ArtistRemoteDataSource {
  Future<ArtistModel> getArtistById(String artistId);
  Future<ArtistModel> getMyArtistProfile();
}

class ArtistRemoteDataSourceImpl implements ArtistRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final TokenStorage tokenStorage;

  ArtistRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
    required this.tokenStorage,
  });

  @override
  Future<ArtistModel> getArtistById(String artistId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$artistId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ArtistModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load artist: ${response.statusCode}');
    }
  }

  @override
  Future<ArtistModel> getMyArtistProfile() async {
    final token = await tokenStorage.getToken();

    print('TOKEN: $token');

    if (token == null) {
      throw Exception('No token found. Please login again.');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      return ArtistModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load my artist profile: ${response.statusCode}',
      );
    }
  }
}
