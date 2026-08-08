import '../../data/models/review_model.dart';
import '../repositories/review_repository.dart';

class GetServiceReviewsUseCase {
  final ReviewRepository repository;
  GetServiceReviewsUseCase(this.repository);

  Future<ReviewsListResponseModel> call(
    String serviceId, {
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String order = 'desc',
  }) {
    return repository.getServiceReviews(serviceId, page: page, limit: limit, sortBy: sortBy, order: order);
  }
}