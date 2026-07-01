import 'package:eventy_customer/features/services/data/models/service_details_model.dart';

import '../repositories/service_repository.dart';

class GetServiceDetailsUseCase {
  final ServiceRepository repository;

  GetServiceDetailsUseCase(this.repository);

  Future<ServiceDetailsResponseModel> call({
    required String id,
    int filesPage = 1,
    int filesLimit = 5,
    int subsPage = 1,
    int subsLimit = 10,
  }) {
    return repository.getServiceDetails(
      id: id,
      filesPage: filesPage,
      filesLimit: filesLimit,
      subsPage: subsPage,
      subsLimit: subsLimit,
    );
  }
}