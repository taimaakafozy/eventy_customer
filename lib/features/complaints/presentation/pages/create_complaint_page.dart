import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/widgets/primary_button.dart';
import 'package:eventy_customer/core/widgets/primary_text_field.dart';
import 'package:eventy_customer/core/widgets/snackbar_helper.dart';
import 'package:eventy_customer/features/complaints/data/models/create_complaint_request_model.dart';
import 'package:eventy_customer/features/complaints/presentation/blocs/create_complaint/create_complaint_cubit.dart';
import 'package:eventy_customer/features/complaints/presentation/blocs/create_complaint/create_complaint_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateComplaintPage extends StatelessWidget {
  const CreateComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreateComplaintCubit>(),
      child: const _CreateComplaintView(),
    );
  }
}

class _CreateComplaintView extends StatefulWidget {
  const _CreateComplaintView();

  @override
  State<_CreateComplaintView> createState() => _CreateComplaintViewState();
}

class _CreateComplaintViewState extends State<_CreateComplaintView> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("New Complaint")),
      body: BlocListener<CreateComplaintCubit, CreateComplaintState>(
        listener: (context, state) {
          if (state is CreateComplaintSuccess) {
            showAppSnackBar(context, message: "Your complaint has been submitted", type: SnackBarType.success);
            Navigator.pop(context, true);
          }
          if (state is CreateComplaintError) {
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(.06),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: theme.primaryColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Tell us what happened. Our team reviews all complaints and gets back to you as soon as possible.",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryTextField(
                  label: "Subject",
                  icon: Icons.short_text_rounded,
                  controller: _subjectController,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Please enter a subject";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PrimaryTextField(
                  label: "Description",
                  icon: Icons.notes_rounded,
                  controller: _descriptionController,
                  maxLines: 6,
                  validator: (v) {
                    if (v == null || v.trim().length < 10) {
                      return "Please provide more details (at least 10 characters)";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                BlocBuilder<CreateComplaintCubit, CreateComplaintState>(
                  builder: (context, state) {
                    final isLoading = state is CreateComplaintLoading;
                    return PrimaryButton(
                      title: isLoading ? "Submitting..." : "Submit Complaint",
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<CreateComplaintCubit>().submit(
                                      CreateComplaintRequestModel(
                                        targetType: "GENERAL",
                                        subject: _subjectController.text.trim(),
                                        description: _descriptionController.text.trim(),
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