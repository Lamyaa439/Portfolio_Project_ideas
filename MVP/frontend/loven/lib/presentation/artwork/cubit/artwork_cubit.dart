import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/artwork_remote_datasource.dart';
import 'artwork_state.dart';

class ArtworkCubit extends Cubit<ArtworkState> {
  final ArtworkRemoteDataSource _remoteDataSource;

  ArtworkCubit(this._remoteDataSource) : super(ArtworkInitial());

  Future<void> listPublicArtworks({
    int limit = 20,
    int offset = 0,
    String status = 'available',
  }) async {
    emit(ArtworkLoading());

    try {
      final data = await _remoteDataSource.listPublicArtworks(
        limit: limit,
        offset: offset,
        status: status,
      );

      emit(ArtworksLoaded(data['artworks'] ?? data['data'] ?? []));
    } catch (e) {
      emit(ArtworkError(e.toString()));
    }
  }

  Future<void> searchArtworks({
    required String query,
    int limit = 20,
    int offset = 0,
  }) async {
    emit(ArtworkLoading());

    try {
      final data = await _remoteDataSource.searchArtworks(
        query: query,
        limit: limit,
        offset: offset,
      );

      emit(ArtworksLoaded(data['artworks'] ?? data['data'] ?? []));
    } catch (e) {
      emit(ArtworkError(e.toString()));
    }
  }

  Future<void> listMyArtworks({
    int limit = 20,
    int offset = 0,
  }) async {
    emit(ArtworkLoading());

    try {
      final data = await _remoteDataSource.listMyArtworks(
        limit: limit,
        offset: offset,
      );

      emit(ArtworksLoaded(data['artworks'] ?? data['data'] ?? []));
    } catch (e) {
      emit(ArtworkError(e.toString()));
    }
  }

  Future<void> getArtwork({
    required String artworkId,
  }) async {
    emit(ArtworkLoading());

    try {
      final artwork = await _remoteDataSource.getArtwork(
        artworkId: artworkId,
      );

      emit(ArtworkLoaded(artwork));
    } catch (e) {
      emit(ArtworkError(e.toString()));
    }
  }

  Future<void> createArtwork({
    required String title,
    required String description,
    required double price,
    required String imageUrl,
    String? category,
    String? medium,
    String? dimensions,
  }) async {
    emit(ArtworkLoading());

    try {
      final artwork = await _remoteDataSource.createArtwork(
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
        category: category,
        medium: medium,
        dimensions: dimensions,
      );

      emit(ArtworkLoaded(artwork));
    } catch (e) {
      emit(ArtworkError(e.toString()));
    }
  }

  Future<void> updateArtwork({
    required String artworkId,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    String? medium,
    String? dimensions,
    String? status,
  }) async {
    emit(ArtworkLoading());

    try {
      final artwork = await _remoteDataSource.updateArtwork(
        artworkId: artworkId,
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
        category: category,
        medium: medium,
        dimensions: dimensions,
        status: status,
      );

      emit(ArtworkLoaded(artwork));
    } catch (e) {
      emit(ArtworkError(e.toString()));
    }
  }

  Future<void> deleteArtwork({
    required String artworkId,
  }) async {
    emit(ArtworkLoading());

    try {
      await _remoteDataSource.deleteArtwork(
        artworkId: artworkId,
      );

      emit(ArtworkSuccess('Artwork deleted successfully'));
    } catch (e) {
      emit(ArtworkError(e.toString()));
    }
  }
}
