import '../../data/models/favorite_response_model.dart';
import '../../data/models/favorites_list_model.dart';

abstract class FavoriteRepository {
  Future<FavoriteResponse> addToFavorite({required String targetType, required String targetId});

  Future<void> removeFromFavorite({required String targetType, required String targetId});

  Future<FavoritesListResponseModel> getFavorites({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
    String? targetType,
  });
}