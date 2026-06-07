import 'package:eventy_customer/core/constants/app_assets.dart';
import 'package:eventy_customer/core/widgets/app_logo.dart';
import 'package:eventy_customer/core/widgets/background_widget.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_content_container.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/primary_text_field.dart';
import '../blocs/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

    // final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor: isDark ? AppColors.splashDark : AppColors.splashLight,
      body: BackgroundWidget(
        image: AppAssets.DarkBackground,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

              child: Form(
                key: _formKey,

                child: Column(
                  mainAxisSize: MainAxisSize.min,

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

                    /// Form Container
                    AppContentContainer(
                      child: ListView(
                        children: [
                          /// Subtitle
                          Text(
                            "Sign in to continue to your account",

                            textAlign: TextAlign.center,

                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.65),
                              // color: AppColors.goldText,
                              height: 1.4,
                            ),
                          ),

                          SizedBox(height: height * 0.03),

                          /// Email
                          PrimaryTextField(
                            label: "Email Address",

                            icon: Icons.email_rounded,

                            controller: _emailController,

                            keyboardType: TextInputType.emailAddress,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }

                              return null;
                            },
                          ),

                          SizedBox(height: height * 0.02),

                          /// Password
                          PrimaryTextField(
                            label: "Password",

                            icon: Icons.lock_rounded,

                            controller: _passwordController,

                            isPassword: true,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
                              }

                              return null;
                            },
                          ),

                          SizedBox(height: height * 0.02),

                          /// Forgot Password
                          Align(
                            alignment: Alignment.centerLeft,

                            child: GestureDetector(
                              onTap: () {},

                              child: Text(
                                "?Forgot Password",

                                style: TextStyle(
                                  color: AppColors.goldText,

                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: height * 0.02),

                          /// Login Button
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              final isLoading = state is LoginLoading;

                              return PrimaryButton(
                                title: isLoading ? "Signing In..." : "Sign In",

                                onPressed: () {
                                  if (isLoading) {
                                    return;
                                  }

                                  if (_formKey.currentState!.validate()) {
                                    context.read<LoginCubit>().login(
                                      _emailController.text.trim(),

                                      _passwordController.text.trim(),
                                    );
                                  }
                                },
                              );
                            },
                          ),

                          SizedBox(height: height * 0.03),

                          GestureDetector(
                            onTap: () {},

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "? Sign Up",

                                  style: TextStyle(
                                    color: AppColors.goldText,

                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  "?Don't have an account",

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

                    /// Footer
                    Text(
                      "Eventy © 2026",

                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.45,
                        ),
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
