import '../repository/favorite_repository.dart';

class RemoveFromFavoriteUseCase {
  final FavoriteRepository repository;

  RemoveFromFavoriteUseCase(this.repository);

  Future<void> call({required String targetType, required String targetId}) {
    return repository.removeFromFavorite(targetType: targetType, targetId: targetId);
  }
}