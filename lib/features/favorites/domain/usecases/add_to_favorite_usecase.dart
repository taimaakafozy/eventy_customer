import '../../data/models/favorite_response_model.dart';
import '../repository/favorite_repository.dart';

class AddToFavoriteUseCase {
  final FavoriteRepository repository;

  AddToFavoriteUseCase(this.repository);

  Future<FavoriteResponse> call({
    required String targetType,
    required String targetId,
  }) {
    return repository.addToFavorite(
      targetType: targetType,
      targetId: targetId,
    );
  }
}