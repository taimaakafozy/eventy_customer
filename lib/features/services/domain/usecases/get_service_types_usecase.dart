import '../../data/models/service_type_model.dart';
import '../repositories/service_repository.dart';

class GetServiceTypesUseCase {
  final ServiceRepository repository;

  GetServiceTypesUseCase(
    this.repository,
  );

  Future<List<ServiceTypeModel>> call() {
    return repository.getServiceTypes();
  }
}