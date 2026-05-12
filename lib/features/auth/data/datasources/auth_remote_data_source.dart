
import '../../../../core/network/dio_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String phone, String password);
  Future<bool> logout();

}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> login(String phone, String password) async {
    final query = '''
  mutation {
    login(phone: "$phone", password: "$password"){
      access_token
      accountTypeLabel
    }
  }
  ''';

    final response = await client.postQuery(query);

    if (response.data['errors'] != null) {
      throw Exception(response.data['errors'][0]['message']);
    }

    final data = response.data['data']['login'];

    return {
      "token": data['access_token'],
      "role": data['accountTypeLabel'],
    };
  }
  @override
  Future<bool> logout() async {
    const query = r'''
      mutation {
        logout
      }
    ''';

    final response = await client.postQuery(query);

    if (response.data['errors'] != null) {
      final message = response.data['errors'][0]['message'];
      throw Exception(message);
    }

    return response.data['data']['logout'] == true;
  }

}