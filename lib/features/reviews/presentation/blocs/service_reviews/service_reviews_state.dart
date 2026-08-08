import '../../../data/models/review_model.dart';

abstract class ServiceReviewsState {}

class ServiceReviewsLoading extends ServiceReviewsState {}

class ServiceReviewsLoaded extends ServiceReviewsState {
  final List<ReviewModel> items;
  final int total;
  final bool hasReachedEnd;
  final bool isLoadingMore;

  ServiceReviewsLoaded({
    required this.items,
    required this.total,
    required this.hasReachedEnd,
    this.isLoadingMore = false,
  });

  ServiceReviewsLoaded copyWith({List<ReviewModel>? items, bool? hasReachedEnd, bool? isLoadingMore}) {
    return ServiceReviewsLoaded(
      items: items ?? this.items,
      total: total,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ServiceReviewsError extends ServiceReviewsState {
  final String message;
  ServiceReviewsError(this.message);
}