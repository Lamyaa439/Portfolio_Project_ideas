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

  final List<String> _categoryTags = [
    'All',
    'Oil Painting',
    'Calligraphy',
    'Photography',
    'Digital Art'
  ];

  HomeBloc() : super(HomeLoading()) {
    // Initial Fetch
    on<FetchHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        await Future.delayed(const Duration(seconds: 1));

        emit(HomeLoaded(
          allArtworks: _artworksTable,
          categories: _categoryTags,
          artPieces: _artworksTable,
        ));
      } catch (e) {
        emit(HomeError("Failed to fetch from PostgreSQL backend"));
      }
    });

    // In-Memory Filter Action
    on<FilterArtworks>((event, emit) {
      if (state is! HomeLoaded) return;

      final currentState = state as HomeLoaded;

      final search = event.searchText ?? currentState.searchQuery;
      final category = event.category ?? currentState.selectedCategory;

      final filteredList = currentState.allArtworks.where((art) {
        final matchesSearch = search.isEmpty ||
            art['title'].toLowerCase().contains(search.toLowerCase());

        final matchesCategory =
            category == 'All' || art['category'] == category;

        return matchesSearch && matchesCategory;
      }).toList();

      emit(currentState.copyWith(
        artPieces: filteredList,
        searchQuery: search,
        selectedCategory: category,
      ));
    });
  }
}
