import '../../data/models/complaint_model.dart';
import '../../data/models/create_complaint_request_model.dart';

abstract class ComplaintRepository {
  Future<ComplaintModel> createComplaint(CreateComplaintRequestModel request);

  Future<ComplaintsListResponseModel> getComplaints({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
    String? status,
    String? targetType,
    String? search,
  });

  Future<ComplaintModel> getComplaintDetails(String id);
}