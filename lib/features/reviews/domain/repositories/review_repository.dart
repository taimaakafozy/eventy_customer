import '../../data/models/create_review_request_model.dart';
import '../../data/models/review_model.dart';

abstract class ReviewRepository {
  Future<ReviewModel> createReview(String bookingId, CreateReviewRequestModel request);

  Future<ReviewsListResponseModel> getServiceReviews(
    String serviceId, {
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
  });

  Future<ReviewModel?> getMyReview(String bookingId);
}