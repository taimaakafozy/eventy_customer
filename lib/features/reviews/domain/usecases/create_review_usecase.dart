import '../../data/models/create_review_request_model.dart';
import '../../data/models/review_model.dart';
import '../repositories/review_repository.dart';

class CreateReviewUseCase {
  final ReviewRepository repository;
  CreateReviewUseCase(this.repository);

  Future<ReviewModel> call(String bookingId, CreateReviewRequestModel request) {
    return repository.createReview(bookingId, request);
  }
}