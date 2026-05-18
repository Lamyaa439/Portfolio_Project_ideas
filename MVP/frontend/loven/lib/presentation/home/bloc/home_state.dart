import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Map<String, dynamic>> allArtworks;

  final List<String> categories;
  final List<dynamic> artPieces;

  final String selectedCategory;
  final String searchQuery;

  HomeLoaded({
    required this.allArtworks,
    required this.categories,
    required this.artPieces,
    this.selectedCategory = 'All',
    this.searchQuery = '',
  });

  HomeLoaded copyWith({
    List<Map<String, dynamic>>? allArtworks,
    List<String>? categories,
    List<dynamic>? artPieces,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return HomeLoaded(
      allArtworks: allArtworks ?? this.allArtworks,
      categories: categories ?? this.categories,
      artPieces: artPieces ?? this.artPieces,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props =>
      [allArtworks, categories, artPieces, selectedCategory, searchQuery];
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
