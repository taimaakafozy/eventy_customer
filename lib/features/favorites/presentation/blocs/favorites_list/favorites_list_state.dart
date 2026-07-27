import '../../../data/models/favorites_list_model.dart';

abstract class FavoritesListState {}

class FavoritesListInitial extends FavoritesListState {}

class FavoritesListLoading extends FavoritesListState {}

class FavoritesListLoaded extends FavoritesListState {
  final List<FavoriteItemModel> items;
  final bool hasReachedEnd;

  FavoritesListLoaded({required this.items, required this.hasReachedEnd});
}

class FavoritesListError extends FavoritesListState {
  final String message;
  FavoritesListError(this.message);
}