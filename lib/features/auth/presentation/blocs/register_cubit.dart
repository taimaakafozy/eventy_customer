import 'package:eventy_customer/features/auth/data/models/register_request_model.dart';
import 'package:eventy_customer/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUsecase registerUseCase;

  RegisterCubit(this.registerUseCase)
      : super(RegisterInitial());

  Future<void> register(
    RegisterRequestModel request,
  ) async {
    try {
      emit(RegisterLoading());

      final response = await registerUseCase(request);

      emit(
        RegisterSuccess(
          message: response.message,
          email: response.data.email,
          otpCode: response.data.otpCode,
        ),
      );
    } catch (e) {
      emit(
        RegisterError(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}