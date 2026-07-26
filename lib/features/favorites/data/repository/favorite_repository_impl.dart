import 'package:eventy_customer/features/favorites/data/datasource/favorite_remote_datasource.dart';
import 'package:eventy_customer/features/favorites/data/models/favorite_response_model.dart';
import 'package:eventy_customer/features/favorites/domain/repository/favorite_repository.dart';

class FavoriteRepositoryImpl
    implements FavoriteRepository {

  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<FavoriteResponse> addToFavorite({
    required String targetType,
    required String targetId,
  }) {
    return remoteDataSource.addToFavorite(
      targetType: targetType,
      targetId: targetId,
    );
  }
}