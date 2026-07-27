import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_complaint_details_usecase.dart';
import 'complaint_details_state.dart';

class ComplaintDetailsCubit extends Cubit<ComplaintDetailsState> {
  final GetComplaintDetailsUseCase getComplaintDetailsUseCase;
  ComplaintDetailsCubit(this.getComplaintDetailsUseCase) : super(ComplaintDetailsLoading());

  Future<void> loadDetails(String id) async {
    emit(ComplaintDetailsLoading());
    try {
      final complaint = await getComplaintDetailsUseCase(id);
      emit(ComplaintDetailsLoaded(complaint));
    } catch (e) {
      emit(ComplaintDetailsError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}