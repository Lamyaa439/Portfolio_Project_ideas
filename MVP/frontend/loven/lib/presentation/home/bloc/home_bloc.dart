import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final List<Map<String, dynamic>> _artworksTable = [
    {
      "id": 1,
      "title": "Sunset over Riyadh",
      "artist_id": 101,
      "price": 1200,
      "image_url": "images/art1.jpg",
      "category": "Oil Painting"
    },
    {
      "id": 2,
      "title": "Modern Calligraphy",
      "artist_id": 102,
      "price": 850,
      "image_url": "images/art2.jpg",
      "category": "Calligraphy"
    },
    {
      "id": 3,
      "title": "Desert Silence",
      "artist_id": 103,
      "price": 2100,
      "image_url": "images/art3.jpg",
      "category": "Photography"
    },
    {
      "id": 4,
      "title": "Geometric Soul",
      "artist_id": 101,
      "price": 950,
      "image_url": "images/art4.jpg",
      "category": "Digital Art"
    },
    {
      "id": 5,
      "title": "Al-Ula Dreams",
      "artist_id": 104,
      "price": 3000,
      "image_url": "images/art5.jpg",
      "category": "Oil Painting"
    },
  ];

  HomeBloc() : super(HomeLoading()) {
    // 1. Existing Initial Fetch
    on<FetchHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        await Future.delayed(const Duration(seconds: 2));
        final randomSuggestions =
            List<Map<String, dynamic>>.from(_artworksTable)..shuffle();

        emit(HomeLoaded(
          categories: ['New Arrivals', 'Trending', 'Local Artists'],
          artPieces: randomSuggestions,
        ));
      } catch (e) {
        emit(HomeError("Failed to fetch from PostgreSQL backend"));
      }
    });

    // 2. NEW: Filtering and Search Logic
    on<FilterArtworks>((event, emit) async {
      emit(HomeLoading()); // Show loader while filtering
      try {
        await Future.delayed(
            const Duration(milliseconds: 500)); // Simulate logic delay

        final filteredList = _artworksTable.where((art) {
          // Check Search Text (matches "sunset" in image_a36675.png)
          final matchesSearch = event.searchText == null ||
              art['title']
                  .toLowerCase()
                  .contains(event.searchText!.toLowerCase());

          // Check Category
          final matchesCategory = event.category == null ||
              event.category == 'All' ||
              art['category'] == event.category;

          // Check Price Range
          final matchesPrice = art['price'] >= (event.minPrice ?? 0) &&
              art['price'] <= (event.maxPrice ?? double.infinity);

          return matchesSearch && matchesCategory && matchesPrice;
        }).toList();

        emit(HomeLoaded(
          // Change labels based on if it's a search or a category filter
          categories: event.searchText != null
              ? ['Search Results']
              : ['Filtered Results'],
          artPieces: filteredList,
        ));
      } catch (e) {
        emit(HomeError("Failed to apply filters"));
      }
    });
  }
}
