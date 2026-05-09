import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<FetchHomeData>((event, emit) async {
      emit(HomeLoading());
      try {
        //here to call python and DB backend
        await Future.delayed(const Duration(seconds: 2));

        emit(HomeLoaded(
          categories: ['My Orders', 'top liked', 'artist'],
          artPieces: [
            {"title": "a cat", "artist": "name", "likes": 100}
          ],
        ));
      } catch (e) {
        emit(HomeError("Failed to load art"));
      }
    });
  }
}
