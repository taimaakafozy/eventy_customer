import 'package:eventy_customer/features/services/data/models/available_services_model/available_services_response_model.dart';
import 'package:eventy_customer/features/services/data/models/service_details_model.dart';

import '../../domain/repositories/service_repository.dart';
import '../datasources/service_remote_data_source.dart';
import '../models/service_type_model.dart';

class ServiceRepositoryImpl
    implements ServiceRepository {
  final ServiceRemoteDataSource remote;

  ServiceRepositoryImpl(this.remote);

  @override
  Future<List<ServiceTypeModel>> getServiceTypes() {
    return remote.getServiceTypes();
  }

    @override
  Future<AvailableServicesResponseModel> getAvailableServices({
String? type,    int page = 1,
    int limit = 10,
  }) {
    return remote.getAvailableServices(
      type: type,
      page: page,
      limit: limit,
    );
  }

  @override
Future<ServiceDetailsResponseModel> getServiceDetails({
  required String id,
  int filesPage = 1,
  int filesLimit = 5,
  int subsPage = 1,
  int subsLimit = 10,
  String? date,
}) {
  return remote.getServiceDetails(
    id: id,
    filesPage: filesPage,
    filesLimit: filesLimit,
    subsPage: subsPage,
    subsLimit: subsLimit,
    date: date,
  );
}
}