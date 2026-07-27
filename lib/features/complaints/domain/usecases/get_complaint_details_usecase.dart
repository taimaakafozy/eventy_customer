import '../../data/models/complaint_model.dart';
import '../repositories/complaint_repository.dart';

class GetComplaintDetailsUseCase {
  final ComplaintRepository repository;
  GetComplaintDetailsUseCase(this.repository);

  Future<ComplaintModel> call(String id) => repository.getComplaintDetails(id);
}