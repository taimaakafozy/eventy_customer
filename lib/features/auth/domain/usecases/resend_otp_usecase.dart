import '../../data/models/resend_otp_request_model.dart';
import '../../data/models/resend_otp_response_model.dart';
import '../repositories/auth_repository.dart';

class ResendOtpUsecase {
  final AuthRepository repository;

  ResendOtpUsecase(this.repository);

  Future<ResendOtpResponseModel> call(
    ResendOtpRequestModel request,
  ) {
    return repository.resendOtp(request);
  }
}