import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_data_source.dart';
import '../models/create_review_request_model.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remote;

  ReviewRepositoryImpl(this.remote);

  @override
  Future<ReviewModel> createReview(String bookingId, CreateReviewRequestModel request) {
    return remote.createReview(bookingId, request);
  }

  @override
  Future<ReviewsListResponseModel> getServiceReviews(
    String serviceId, {
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
  }) {
    return remote.getServiceReviews(serviceId, page: page, limit: limit, sortBy: sortBy, order: order);
  }

  @override
  Future<ReviewModel?> getMyReview(String bookingId) {
    return remote.getMyReview(bookingId);
  }
}