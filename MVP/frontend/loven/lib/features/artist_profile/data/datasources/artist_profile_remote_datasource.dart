import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/artist_model.dart';

abstract class ArtistProfileRemoteDataSource {
  Future<ArtistModel> getArtistById(String artistId);
}

class ArtistProfileRemoteDataSourceImpl
    implements ArtistProfileRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ArtistProfileRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<ArtistModel> getArtistById(String artistId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$artistId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return ArtistModel.fromJson(data);
    }

    throw Exception(
      data['error'] ?? 'Failed to load artist profile',
    );
  }
}