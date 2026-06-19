import 'package:eventy_customer/core/constants/app_assets.dart';
import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/widgets/app_logo.dart';
import 'package:eventy_customer/core/widgets/background_widget.dart';
import 'package:eventy_customer/core/widgets/primary_button.dart';
import 'package:eventy_customer/core/widgets/primary_text_field.dart';
import 'package:eventy_customer/core/widgets/snackbar_helper.dart';
import 'package:eventy_customer/features/auth/data/models/resend_otp_request_model.dart';
import 'package:eventy_customer/features/auth/data/models/reset_password_request_model.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/app_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/resend_otp_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/resend_otp_state.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/reset_password_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/reset_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class ResetPasswordOtpPage extends StatefulWidget {
  final String email;

  const ResetPasswordOtpPage({super.key, required this.email});

  @override
  @override
  State<ResetPasswordOtpPage> createState() => _ResetPasswordOtpPageState();
}

class _ResetPasswordOtpPageState extends State<ResetPasswordOtpPage> {
  final TextEditingController _otpController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final height = MediaQuery.of(context).size.height;

    final defaultPinTheme = PinTheme(
      width: 55,
      height: 60,
      textStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.textTheme.bodyLarge?.color,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.4)),
      ),
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              showAppSnackBar(
                context,
                message: state.message,
                type: SnackBarType.success,
              );
              print(
                "OTP PAGE APP CUBIT: ${identityHashCode(context.read<AppCubit>())}",
              );
              context.read<AppCubit>().checkAuth();
              // Navigator.of(context).popUntil((route) => route.isFirst);

              Navigator.of(context).pop();

              print(context.read<AppCubit>().state);
              Future.delayed(const Duration(milliseconds: 300), () {
                print(
                  "OTP AFTER: ${context.read<AppCubit>().state.runtimeType}",
                );
              });
            }

            if (state is ResetPasswordError) {
              showAppSnackBar(
                context,
                message: state.message,
                type: SnackBarType.error,
              );
            }
          },
        ),

        BlocListener<ResendOtpCubit, ResendOtpState>(
          listener: (context, state) {
            if (state is ResendOtpSuccess) {
              showAppSnackBar(
                context,
                message: state.message,
                type: SnackBarType.success,
              );
              print("EMAIL: ${state.email}");
              print("OTP: ${state.otpCode}");
            }

            if (state is ResendOtpError) {
              showAppSnackBar(
                context,
                message: state.message,
                type: SnackBarType.error,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: BackgroundWidget(
          image: AppAssets.DarkBackground,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SecondaryLogo(),

                    SizedBox(height: height * 0.05),

                    Text(
                      "Reset Password",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "We've sent a reset code to",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.7,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.email,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldText,
                      ),
                    ),

                    SizedBox(height: height * 0.06),

                    Pinput(
                      controller: _otpController,
                      length: 6,
                      defaultPinTheme: defaultPinTheme,

                      focusedPinTheme: defaultPinTheme.copyDecorationWith(
                        border: Border.all(color: AppColors.gold, width: 2),
                      ),

                      submittedPinTheme: defaultPinTheme.copyDecorationWith(
                        color: AppColors.gold.withOpacity(0.12),
                        border: Border.all(color: AppColors.gold),
                      ),

                      keyboardType: TextInputType.number,

                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,

                      validator: (value) {
                        if (value == null || value.length != 6) {
                          return "Enter the 6-digit OTP";
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: height * 0.03),

                    PrimaryTextField(
                      label: "New Password",
                      icon: Icons.lock_outline,
                      controller: _passwordController,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return "Password must be at least 8 characters";
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: height * 0.06),

                    SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                        builder: (context, state) {
                          return PrimaryButton(
                            title: state is ResetPasswordLoading
                                ? "Resetting..."
                                : "Reset Password",

                            onPressed: state is ResetPasswordLoading
                                ? null
                                : () {
                                    if (_otpController.text.length != 6) {
                                      showAppSnackBar(
                                        context,
                                        message: "Please enter the OTP code",
                                        type: SnackBarType.error,
                                      );
                                      return;
                                    }

                                    if (_passwordController.text.length < 8) {
                                      showAppSnackBar(
                                        context,
                                        message:
                                            "Password must be at least 8 characters",
                                        type: SnackBarType.error,
                                      );

                                      return;
                                    }

                                    context
                                        .read<ResetPasswordCubit>()
                                        .resetPassword(
                                          ResetPasswordRequestModel(
                                            email: widget.email,
                                            code: _otpController.text,
                                            newPassword:
                                                _passwordController.text,
                                          ),
                                        );
                                  },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    BlocBuilder<ResendOtpCubit, ResendOtpState>(
                      builder: (context, resendState) {
                        return TextButton(
                          onPressed: resendState is ResendOtpLoading
                              ? null
                              : () {
                                  context.read<ResendOtpCubit>().resendOtp(
                                    ResendOtpRequestModel(email: widget.email),
                                  );
                                },

                          child: Text(
                            resendState is ResendOtpLoading
                                ? "Sending..."
                                : "Resend OTP",
                            style: TextStyle(
                              color: AppColors.darkBackground,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: height * 0.05),

                    Text(
                      "Eventy © 2026",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.goldText
                            : AppColors.lightText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
