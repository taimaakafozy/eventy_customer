import '../../../data/models/review_model.dart';

abstract class MyReviewState {}

class MyReviewLoading extends MyReviewState {}

/// review == null يعني: لم يُقيَّم هذا الحجز بعد
class MyReviewLoaded extends MyReviewState {
  final ReviewModel? review;
  MyReviewLoaded(this.review);
}

class MyReviewError extends MyReviewState {
  final String message;
  MyReviewError(this.message);
}