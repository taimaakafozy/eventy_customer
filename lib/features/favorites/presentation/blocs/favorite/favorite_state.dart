abstract class FavoriteState {
  const FavoriteState();
}

class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}

class FavoriteLoading extends FavoriteState {
  final String targetId;

  const FavoriteLoading(this.targetId);
}

class FavoriteSuccess extends FavoriteState {
  final String targetId;
  final bool isFavorite;

  const FavoriteSuccess({
    required this.targetId,
    required this.isFavorite,
  });
}

class FavoriteError extends FavoriteState {
  final String targetId;
  final String message;

  const FavoriteError({
    required this.targetId,
    required this.message,
  });
}