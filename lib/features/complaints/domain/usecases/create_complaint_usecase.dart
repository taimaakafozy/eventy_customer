import '../../data/models/complaint_model.dart';
import '../../data/models/create_complaint_request_model.dart';
import '../repositories/complaint_repository.dart';

class CreateComplaintUseCase {
  final ComplaintRepository repository;
  CreateComplaintUseCase(this.repository);

  Future<ComplaintModel> call(CreateComplaintRequestModel request) {
    return repository.createComplaint(request);
  }
}