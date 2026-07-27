import '../../../../core/network/dio_client.dart';
import '../models/complaint_model.dart';
import '../models/create_complaint_request_model.dart';

abstract class ComplaintRemoteDataSource {
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

class ComplaintRemoteDataSourceImpl implements ComplaintRemoteDataSource {
  final DioClient client;

  ComplaintRemoteDataSourceImpl(this.client);

  @override
  Future<ComplaintModel> createComplaint(CreateComplaintRequestModel request) async {
    final response = await client.dio.post('complaints', data: request.toJson());
    final data = response.data;

    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to submit complaint');
    }

    return ComplaintModel.fromJson(data['data']);
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
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sortBy': sortBy,
      'order': order,
    };

    if (status != null && status.isNotEmpty) query['status'] = status;
    if (targetType != null && targetType.isNotEmpty) query['targetType'] = targetType;
    if (search != null && search.trim().isNotEmpty) query['search'] = search.trim();

    final response = await client.dio.get('complaints', queryParameters: query);
    final data = response.data;

    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to load complaints');
    }

    return ComplaintsListResponseModel.fromJson(data);
  }

  @override
  Future<ComplaintModel> getComplaintDetails(String id) async {
    final response = await client.dio.get('complaints/$id');
    final data = response.data;

    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to load complaint details');
    }

    return ComplaintModel.fromJson(data['data']);
  }
}