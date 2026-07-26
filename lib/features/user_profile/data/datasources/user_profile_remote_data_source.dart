import '../../../../core/network/dio_client.dart';
import '../models/user_profile_model.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final DioClient client;

  UserProfileRemoteDataSourceImpl(this.client);

  @override
  Future<UserProfileModel> getProfile() async {
    /// ⚠️ الـ id بالمسار مطلوب شكليًا فقط — الباك اند يتجاهله لغير الأدمن
    /// ويعتمد مباشرة على المستخدم صاحب التوكن، لذا نمرر placeholder ثابت
    final response = await client.dio.get('users/me');
    final data = response.data;

    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to load profile');
    }

    return UserProfileModel.fromJson(data['data']);
  }
}