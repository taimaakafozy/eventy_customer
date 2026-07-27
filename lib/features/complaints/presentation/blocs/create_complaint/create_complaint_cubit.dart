import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/create_complaint_usecase.dart';
import '../../../data/models/create_complaint_request_model.dart';
import 'create_complaint_state.dart';

class CreateComplaintCubit extends Cubit<CreateComplaintState> {
  final CreateComplaintUseCase createComplaintUseCase;
  CreateComplaintCubit(this.createComplaintUseCase) : super(CreateComplaintInitial());

  Future<void> submit(CreateComplaintRequestModel request) async {
    emit(CreateComplaintLoading());
    try {
      final complaint = await createComplaintUseCase(request);
      emit(CreateComplaintSuccess(complaint));
    } catch (e) {
      emit(CreateComplaintError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
