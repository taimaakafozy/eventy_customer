import '../../../data/models/review_model.dart';

abstract class CreateReviewState {}

class CreateReviewInitial extends CreateReviewState {}

class CreateReviewLoading extends CreateReviewState {}

class CreateReviewSuccess extends CreateReviewState {
  final ReviewModel review;
  CreateReviewSuccess(this.review);
}

class CreateReviewError extends CreateReviewState {
  final String message;
  CreateReviewError(this.message);
}