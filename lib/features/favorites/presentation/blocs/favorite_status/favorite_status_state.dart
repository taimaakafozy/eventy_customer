class FavoriteStatusState {
  /// كل عنصر بصيغة "TYPE:ID" — مثال: "SERVICE:68960fc1-..."
  final Set<String> favoriteKeys;
  final Set<String> loadingKeys;

  const FavoriteStatusState({
    this.favoriteKeys = const {},
    this.loadingKeys = const {},
  });

  FavoriteStatusState copyWith({
    Set<String>? favoriteKeys,
    Set<String>? loadingKeys,
  }) {
    return FavoriteStatusState(
      favoriteKeys: favoriteKeys ?? this.favoriteKeys,
      loadingKeys: loadingKeys ?? this.loadingKeys,
    );
  }
}