import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/widgets/primary_button.dart';
import 'package:eventy_customer/core/widgets/primary_text_field.dart';
import 'package:eventy_customer/core/widgets/snackbar_helper.dart';
import 'package:eventy_customer/features/auth/data/models/change_password_request_model.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/change_password_cubit.dart';
import 'package:eventy_customer/features/auth/presentation/blocs/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChangePasswordCubit>(),
      child: const _ChangePasswordView(),
    );
  }
}

class _ChangePasswordView extends StatefulWidget {
  const _ChangePasswordView();

  @override
  State<_ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<_ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            showAppSnackBar(
              context,
              message: "Password changed successfully",
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          }

          if (state is ChangePasswordError) {
            showAppSnackBar(context, message: state.message, type: SnackBarType.error);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Update your password",
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  "Choose a strong password you haven't used before",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(.6),
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryTextField(
                  label: "Current Password",
                  icon: Icons.lock_outline_rounded,
                  controller: _oldPasswordController,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Please enter your current password";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PrimaryTextField(
                  label: "New Password",
                  icon: Icons.lock_reset_outlined,
                  controller: _newPasswordController,
                  isPassword: true,
                  validator: (v) {
                    if (v == null || v.length < 8) return "Password must be at least 8 characters";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PrimaryTextField(
                  label: "Confirm New Password",
                  icon: Icons.lock_reset_outlined,
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: (v) {
                    if (v != _newPasswordController.text) return "Passwords do not match";
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                  builder: (context, state) {
                    final isLoading = state is ChangePasswordLoading;
                    return PrimaryButton(
                      title: isLoading ? "Updating..." : "Update Password",
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<ChangePasswordCubit>().changePassword(
                                      ChangePasswordRequestModel(
                                        oldPassword: _oldPasswordController.text,
                                        newPassword: _newPasswordController.text,
                                      ),
                                    );
                              }
                            },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}