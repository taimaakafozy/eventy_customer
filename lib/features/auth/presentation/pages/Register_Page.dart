import 'dart:io';

import 'package:eventy_customer/core/constants/app_assets.dart';
import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/widgets/app_content_container.dart';
import 'package:eventy_customer/core/widgets/app_logo.dart';
import 'package:eventy_customer/core/widgets/background_widget.dart';
import 'package:eventy_customer/core/widgets/primary_button.dart';
import 'package:eventy_customer/core/widgets/primary_text_field.dart';
import 'package:eventy_customer/core/widgets/snackbar_helper.dart';
import 'package:eventy_customer/features/auth/data/models/register_request_model.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/register_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/register_state.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/resend_otp_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/verify_otp_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/pages/otp_page.dart';
import 'package:eventy_customer/features/auth/presentation/pages/pick_location_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ImagePicker _picker = ImagePicker();
  final _fullNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

  final _passwordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File? profileImage;

  String? selectedLocation;

  double? selectedLatitude;

  double? selectedLongitude;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return;

      setState(() {
        profileImage = File(image.path);
      });

      print("IMAGE: ${image.path}");
    } catch (e) {
      print("IMAGE ERROR: $e");
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => sl<RegisterCubit>(),
      child: Scaffold(
        body: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterLoading) {
              // لا شيء هنا حالياً
            }

            if (state is RegisterSuccess) {
              showAppSnackBar(
                context,
                message: state.message,
                type: SnackBarType.success,
              );
              print("EMAIL: ${state.email}");
              print("OTP: ${state.otpCode}");

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (_) => sl<VerifyOtpCubit>()),
                      BlocProvider(create: (_) => sl<ResendOtpCubit>()),
                    ],
                    child: OtpPage(email: state.email),
                  ),
                ),
              );
            }

            if (state is RegisterError) {
              showAppSnackBar(
                context,
                message: state.message,
                type: SnackBarType.error,
              );
              print("REGISTER ERROR: ${state.message}");
            }
          },
          child: BackgroundWidget(
            image: AppAssets.DarkBackground,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// Logo
                        const SecondaryLogo(),

                        SizedBox(height: height * 0.01),

                        Container(
                          width: 65,
                          height: 2.2,
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        SizedBox(height: height * 0.02),

                        AppContentContainer(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Create your account",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "Join Eventy and start discovering events",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.65),
                                  height: 1.4,
                                ),
                              ),

                              SizedBox(height: height * 0.03),
                              GestureDetector(
                                onTap: () async {
                                  _pickImage();
                                  // final image = await _picker.pickImage(
                                  //   source: ImageSource.gallery,
                                  //   imageQuality: 80,
                                  // );

                                  // print(image?.path);
                                },
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: AppColors.primary
                                          .withOpacity(0.1),
                                      backgroundImage: profileImage != null
                                          ? FileImage(profileImage!)
                                          : null,
                                      child: profileImage == null
                                          ? Icon(
                                              Icons.person,
                                              size: 50,
                                              color: AppColors.goldText,
                                            )
                                          : null,
                                    ),

                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.gold,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height * 0.03),

                              /// Full Name
                              PrimaryTextField(
                                label: "Full Name",
                                icon: Icons.person_outline,
                                controller: _fullNameController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please enter your full name";
                                  }

                                  return null;
                                },
                              ),

                              SizedBox(height: height * 0.02),

                              /// Email
                              PrimaryTextField(
                                label: "Email Address",
                                icon: Icons.email_outlined,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please enter your email";
                                  }

                                  return null;
                                },
                              ),

                              SizedBox(height: height * 0.02),

                              /// Phone
                              PrimaryTextField(
                                label: "Phone Number",
                                icon: Icons.phone_outlined,
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please enter your phone number";
                                  }

                                  return null;
                                },
                              ),

                              SizedBox(height: height * 0.02),

                              /// Password
                              PrimaryTextField(
                                label: "Password",
                                icon: Icons.lock_outline,
                                controller: _passwordController,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.length < 6) {
                                    return "Password must be at least 6 characters";
                                  }

                                  return null;
                                },
                              ),

                              SizedBox(height: height * 0.02),

                              /// Confirm Password
                              PrimaryTextField(
                                label: "Confirm Password",
                                icon: Icons.lock_reset_outlined,
                                controller: _confirmPasswordController,
                                isPassword: true,
                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return "Passwords do not match";
                                  }

                                  return null;
                                },
                              ),

                              SizedBox(height: height * 0.025),

                              GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const PickLocationPage(),
                                    ),
                                  );

                                  if (result != null) {
                                    setState(() {
                                      selectedLocation = result['locationName'];
                                      selectedLatitude = result['latitude'];
                                      selectedLongitude = result['longitude'];
                                    });
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: theme.cardColor.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: AppColors.gold.withOpacity(0.35),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          color: AppColors.gold.withOpacity(
                                            0.15,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.location_on_rounded,
                                          color: AppColors.goldText,
                                          size: 28,
                                        ),
                                      ),

                                      const SizedBox(width: 14),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Location",
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .textTheme
                                                        .bodySmall
                                                        ?.color
                                                        ?.withOpacity(0.6),
                                                  ),
                                            ),

                                            const SizedBox(height: 4),

                                            Text(
                                              selectedLocation?.isNotEmpty ==
                                                      true
                                                  ? selectedLocation!
                                                  : "Tap to choose your location",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 18,
                                        color: AppColors.goldText,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: height * 0.025),

                              /// Register
                              BlocBuilder<RegisterCubit, RegisterState>(
                                builder: (context, state) {
                                  return PrimaryButton(
                                    title: state is RegisterLoading
                                        ? "Creating..."
                                        : "Create Account",
                                    onPressed: state is RegisterLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (selectedLatitude == null ||
                                                  selectedLongitude == null) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Please choose your location",
                                                    ),
                                                  ),
                                                );

                                                return;
                                              }

                                              final request =
                                                  RegisterRequestModel(
                                                    fullName:
                                                        _fullNameController.text
                                                            .trim(),
                                                    email: _emailController.text
                                                        .trim(),
                                                    phoneNumber:
                                                        _phoneController.text
                                                            .trim(),
                                                    password:
                                                        _passwordController
                                                            .text,
                                                    locationName:
                                                        selectedLocation,
                                                    latitude: selectedLatitude,
                                                    longitude:
                                                        selectedLongitude,
                                                    profileImage: profileImage,
                                                  );

                                              context
                                                  .read<RegisterCubit>()
                                                  .register(request);
                                            }
                                          },
                                  );
                                },
                              ),
                              SizedBox(height: height * 0.025),

                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: theme.dividerColor),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text("OR"),
                                  ),
                                  Expanded(
                                    child: Divider(color: theme.dividerColor),
                                  ),
                                ],
                              ),

                              SizedBox(height: height * 0.025),

                              /// Google
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    /// لاحقاً Google Sign In
                                  },
                                  icon: const Icon(
                                    Icons.g_mobiledata,
                                    size: 32,
                                  ),
                                  label: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    child: Text("Continue with Google"),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.goldText,
                                    side: BorderSide(
                                      color: AppColors.gold.withOpacity(0.5),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: height * 0.03),

                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: AppColors.goldText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.03),

                        Text(
                          "Eventy © 2026",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.dark
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
        ),
      ),
    );
  }
}
