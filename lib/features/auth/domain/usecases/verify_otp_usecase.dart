import 'package:eventy_customer/features/auth/data/models/verify_otp_request_model.dart';
import 'package:eventy_customer/features/auth/data/models/verify_otp_response_model.dart';
import 'package:eventy_customer/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUsecase {
  final AuthRepository repository;

  const VerifyOtpUsecase(this.repository);
  Future<VerifyOtpResponseModel> call(
    VerifyOtpRequestModel request,
  ) {
    return repository.verifyOtp(request);
  }
}