import '../../data/models/complaint_model.dart';
import '../repositories/complaint_repository.dart';

class GetComplaintsUseCase {
  final ComplaintRepository repository;
  GetComplaintsUseCase(this.repository);

  Future<ComplaintsListResponseModel> call({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
    String? status,
    String? targetType,
    String? search,
  }) {
    return repository.getComplaints(
      page: page,
      limit: limit,
      sortBy: sortBy,
      order: order,
      status: status,
      targetType: targetType,
      search: search,
    );
  }
}