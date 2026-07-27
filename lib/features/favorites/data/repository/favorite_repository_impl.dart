import 'package:eventy_customer/features/favorites/data/datasource/favorite_remote_datasource.dart';
import 'package:eventy_customer/features/favorites/data/models/favorite_response_model.dart';
import 'package:eventy_customer/features/favorites/data/models/favorites_list_model.dart';
import 'package:eventy_customer/features/favorites/domain/repository/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl(this.remoteDataSource);

  @override
  Future<FavoriteResponse> addToFavorite({required String targetType, required String targetId}) {
    return remoteDataSource.addToFavorite(targetType: targetType, targetId: targetId);
  }

  @override
  Future<void> removeFromFavorite({required String targetType, required String targetId}) {
    return remoteDataSource.removeFromFavorite(targetType: targetType, targetId: targetId);
  }

  @override
  Future<FavoritesListResponseModel> getFavorites({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
    String? targetType,
  }) {
    return remoteDataSource.getFavorites(
      page: page,
      limit: limit,
      sortBy: sortBy,
      order: order,
      targetType: targetType,
    );
  }
}