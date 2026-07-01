import 'package:eventy_customer/features/services/data/models/available_services_model/available_services_response_model.dart';
import 'package:eventy_customer/features/services/data/models/service_details_model.dart';

import '../../../../core/network/dio_client.dart';
import '../models/service_type_model.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceTypeModel>> getServiceTypes();
    Future<AvailableServicesResponseModel> getAvailableServices({
String? type,    int page = 1,
    int limit = 10,
  });
  Future<ServiceDetailsResponseModel> getServiceDetails({
  required String id,
  int filesPage = 1,
  int filesLimit = 5,
  int subsPage = 1,
  int subsLimit = 10,
});
}

class ServiceRemoteDataSourceImpl
    implements ServiceRemoteDataSource {
  final DioClient client;

  ServiceRemoteDataSourceImpl(this.client);

  @override
  Future<List<ServiceTypeModel>> getServiceTypes() async {
    final response = await client.dio.get(
      'services/service-types',
    );

    final data = response.data;

    if (data['success'] != true) {
      throw Exception(
        data['message'] ??
            'Failed to load service types',
      );
    }

    final List list = data['data'];

    return list
        .map(
          (e) => ServiceTypeModel.fromJson(e),
        )
        .toList();
  }
  @override
Future<AvailableServicesResponseModel> getAvailableServices({
  String? type,
  int page = 1,
  int limit = 10,
}) async {

  final query = {
    'page': page,
    'limit': limit,
    'sortBy': 'createdAt',
    'order': 'desc',
  };

  if (type != null) {
    query['type'] = type;
  }

  final response = await client.dio.get(
    'services/available',
    queryParameters: query,
  );

  final data = response.data;

  if (data['success'] != true) {
    throw Exception(
      data['message'] ??
          'Failed to load available services',
    );
  }

  return AvailableServicesResponseModel.fromJson(
    data,
  );
}

@override
Future<ServiceDetailsResponseModel> getServiceDetails({
  required String id,
  int filesPage = 1,
  int filesLimit = 5,
  int subsPage = 1,
  int subsLimit = 10,
}) async {

  final response = await client.dio.get(
    'services/$id',
    queryParameters: {
      'filesPage': filesPage,
      'filesLimit': filesLimit,
      'subsPage': subsPage,
      'subsLimit': subsLimit,
    },
  );

  final data = response.data;

  if (data['success'] != true) {
    throw Exception(
      data['message'] ??
          'Failed to load service details',
    );
  }

  return ServiceDetailsResponseModel.fromJson(data);
}
  
}