import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // Mock data representing rows from your PostgreSQL "artworks" table
  final List<Map<String, dynamic>> _artworksTable = [
    {
      "id": 1,
      "title": "Sunset over Riyadh",
      "artist_id": 101,
      "price": 1200,
      "image_url": "assets/images/art1.jpg"
    },
    {
      "id": 2,
      "title": "Modern Calligraphy",
      "artist_id": 102,
      "price": 850,
      "image_url": "assets/images/art2.jpg"
    },
    {
      "id": 3,
      "title": "Desert Silence",
      "artist_id": 103,
      "price": 2100,
      "image_url": "assets/images/art3.jpg"
    },
    {
      "id": 4,
      "title": "Geometric Soul",
      "artist_id": 101,
      "price": 950,
      "image_url": "assets/images/art4.jpg"
    },
    {
      "id": 5,
      "title": "Al-Ula Dreams",
      "artist_id": 104,
      "price": 3000,
      "image_url": "assets/images/art5.jpg"
    },
  ];

  HomeBloc() : super(HomeLoading()) {
    on<FetchHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        // Logic will eventually involve a GET request to your FastAPI/PostgreSQL endpoint
        await Future.delayed(const Duration(seconds: 2));

        // Shuffling to provide the random suggestions you requested
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
  }
}
