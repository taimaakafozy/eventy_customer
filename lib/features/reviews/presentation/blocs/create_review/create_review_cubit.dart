import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/create_review_request_model.dart';
import '../../../domain/usecases/create_review_usecase.dart';
import 'create_review_state.dart';

class CreateReviewCubit extends Cubit<CreateReviewState> {
  final CreateReviewUseCase createReviewUseCase;
  CreateReviewCubit(this.createReviewUseCase) : super(CreateReviewInitial());

  Future<void> submit(String bookingId, CreateReviewRequestModel request) async {
    emit(CreateReviewLoading());
    try {
      final review = await createReviewUseCase(bookingId, request);
      emit(CreateReviewSuccess(review));
    } catch (e) {
      emit(CreateReviewError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}