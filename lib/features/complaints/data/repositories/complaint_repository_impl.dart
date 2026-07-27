import '../../domain/repositories/complaint_repository.dart';
import '../datasources/complaint_remote_data_source.dart';
import '../models/complaint_model.dart';
import '../models/create_complaint_request_model.dart';

class ComplaintRepositoryImpl implements ComplaintRepository {
  final ComplaintRemoteDataSource remote;

  ComplaintRepositoryImpl(this.remote);

  @override
  Future<ComplaintModel> createComplaint(CreateComplaintRequestModel request) {
    return remote.createComplaint(request);
  }

  @override
  Future<ComplaintsListResponseModel> getComplaints({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
    String? status,
    String? targetType,
    String? search,
  }) {
    return remote.getComplaints(
      page: page,
      limit: limit,
      sortBy: sortBy,
      order: order,
      status: status,
      targetType: targetType,
      search: search,
    );
  }

  @override
  Future<ComplaintModel> getComplaintDetails(String id) {
    return remote.getComplaintDetails(id);
  }
}