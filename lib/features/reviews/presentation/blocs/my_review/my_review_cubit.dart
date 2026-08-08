import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_my_review_usecase.dart';
import 'my_review_state.dart';

class MyReviewCubit extends Cubit<MyReviewState> {
  final GetMyReviewUseCase getMyReviewUseCase;
  MyReviewCubit(this.getMyReviewUseCase) : super(MyReviewLoading());

  Future<void> load(String bookingId) async {
    emit(MyReviewLoading());
    try {
      final review = await getMyReviewUseCase(bookingId);
      emit(MyReviewLoaded(review));
    } catch (e) {
      emit(MyReviewError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}