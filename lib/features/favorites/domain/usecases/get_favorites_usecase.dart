import '../../data/models/favorites_list_model.dart';
import '../repository/favorite_repository.dart';

class GetFavoritesUseCase {
  final FavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<FavoritesListResponseModel> call({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
    String? targetType,
  }) {
    return repository.getFavorites(
      page: page,
      limit: limit,
      sortBy: sortBy,
      order: order,
      targetType: targetType,
    );
  }
}