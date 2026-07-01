import '../../data/models/available_services_model/available_services_response_model.dart';
import '../repositories/service_repository.dart';

class GetAvailableServicesUseCase {
  final ServiceRepository repository;

  GetAvailableServicesUseCase(
    this.repository,
  );

  Future<AvailableServicesResponseModel> call({
    String? type,
    int page = 1,
    int limit = 10,
  }) {
    return repository.getAvailableServices(
      type: type,
      page: page,
      limit: limit,
    );
  }
}