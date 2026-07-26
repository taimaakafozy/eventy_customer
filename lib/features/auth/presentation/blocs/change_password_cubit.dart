import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/change_password_request_model.dart';
import '../../domain/usecases/change_password_usecase.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordCubit(this.changePasswordUseCase) : super(ChangePasswordInitial());

  Future<void> changePassword(ChangePasswordRequestModel request) async {
    emit(ChangePasswordLoading());

    try {
      await changePasswordUseCase(request);
      emit(ChangePasswordSuccess());
    } on DioException catch (e) {
      emit(ChangePasswordError(
        e.response?.data?["message"] ?? "Something went wrong",
      ));
    } catch (e) {
      emit(ChangePasswordError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}