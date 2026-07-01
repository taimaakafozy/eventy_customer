import 'package:eventy_customer/features/services/data/models/available_services_model/available_services_response_model.dart';
import 'package:eventy_customer/features/services/data/models/service_details_model.dart';

import '../../data/models/service_type_model.dart';

abstract class ServiceRepository {
  Future<List<ServiceTypeModel>> getServiceTypes();
  Future<AvailableServicesResponseModel> getAvailableServices({
 String? type,  int page,
  int limit,
});

Future<ServiceDetailsResponseModel> getServiceDetails({
    required String id,
    int filesPage,
    int filesLimit,
    int subsPage,
    int subsLimit,
  });
}