import 'package:eventy_customer/core/network/dio_client.dart';
import 'package:eventy_customer/features/favorites/data/models/favorite_response_model.dart';

abstract class FavoriteRemoteDataSource {
  Future<FavoriteResponse> addToFavorite({
    required String targetType,
    required String targetId,
  });
}

class FavoriteRemoteDataSourceImpl
    implements FavoriteRemoteDataSource {

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
      throw Exception(
        data['message'] ??
            'Failed to add favorite',
      );
    }

    return FavoriteResponse.fromJson(data);
  }
}