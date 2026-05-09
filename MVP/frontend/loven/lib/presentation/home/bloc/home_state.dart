import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeIntial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<String> categories; // [artist, top liked]
  final List<dynamic> artPieces;

  HomeLoaded({required this.categories, required this.artPieces});

  @override
  List<Object> get props => [categories, artPieces];
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);

  @override
  List<Object> get props => [message];
}
