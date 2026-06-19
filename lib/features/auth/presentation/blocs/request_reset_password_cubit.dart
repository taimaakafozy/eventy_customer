import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/request_reset_password_request_model.dart';
import '../../domain/usecases/request_reset_password_usecase.dart';
import 'request_reset_password_state.dart';

class RequestResetPasswordCubit
    extends Cubit<RequestResetPasswordState> {

  final RequestResetPasswordUseCase useCase;

  RequestResetPasswordCubit(this.useCase)
      : super(RequestResetPasswordInitial());

  Future<void> requestReset(
    RequestResetPasswordRequestModel request,
  ) async {

    try {
      emit(RequestResetPasswordLoading());

      final response = await useCase(request);

      emit(
        RequestResetPasswordSuccess(
          message: response.message,
          email: response.data.email,
          otp: response.data.otp,
        ),
      );

    } on DioException catch (e) {

      emit(
        RequestResetPasswordError(
          e.response?.data["message"]
              ?? "Something went wrong",
        ),
      );
    }
  }
}