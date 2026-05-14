import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/artist_model.dart';

abstract class ArtistRemoteDataSource {
  Future<ArtistModel> getArtistById(String artistId);
}

class ArtistRemoteDataSourceImpl implements ArtistRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ArtistRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<ArtistModel> getArtistById(String artistId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/artists/$artistId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return ArtistModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load artist: ${response.statusCode}');
    }
  }
}
