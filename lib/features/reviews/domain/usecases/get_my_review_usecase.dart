import '../../data/models/review_model.dart';
import '../repositories/review_repository.dart';

class GetMyReviewUseCase {
  final ReviewRepository repository;
  GetMyReviewUseCase(this.repository);

  Future<ReviewModel?> call(String bookingId) => repository.getMyReview(bookingId);
}