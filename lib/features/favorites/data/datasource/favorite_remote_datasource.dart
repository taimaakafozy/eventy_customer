import 'package:eventy_customer/core/network/dio_client.dart';
import 'package:eventy_customer/features/favorites/data/models/favorite_response_model.dart';
import 'package:eventy_customer/features/favorites/data/models/favorites_list_model.dart';

abstract class FavoriteRemoteDataSource {
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

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final DioClient client;

  FavoriteRemoteDataSourceImpl(this.client);

  @override
  Future<FavoriteResponse> addToFavorite({
    required String targetType,
    required String targetId,
  }) async {
    final response = await client.dio.post(
      'favorites',
      data: {
        "targetType": targetType,
        "targetId": targetId,
      },
    );

    final data = response.data;

    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to add favorite');
    }

    return FavoriteResponse.fromJson(data);
  }

  @override
  Future<void> removeFromFavorite({
    required String targetType,
    required String targetId,
  }) async {
    final response = await client.dio.delete('favorites/$targetType/$targetId');
    final data = response.data;

    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to remove favorite');
    }
  }

  @override
  Future<FavoritesListResponseModel> getFavorites({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
    String? targetType,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sortBy': sortBy,
      'order': order,
    };

    if (targetType != null && targetType.isNotEmpty) {
      query['targetType'] = targetType;
    }

    final response = await client.dio.get('favorites', queryParameters: query);
    final data = response.data;

    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to load favorites');
    }

    return FavoritesListResponseModel.fromJson(data);
  }
}