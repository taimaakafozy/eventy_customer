import '../../data/models/favorite_response_model.dart';

abstract class FavoriteRepository {
  Future<FavoriteResponse> addToFavorite({
    required String targetType,
    required String targetId,
  });
}