import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/widgets/primary_button.dart';
import 'package:eventy_customer/core/widgets/snackbar_helper.dart';
import 'package:eventy_customer/features/reviews/data/models/create_review_request_model.dart';
import 'package:eventy_customer/features/reviews/presentation/blocs/create_review/create_review_cubit.dart';
import 'package:eventy_customer/features/reviews/presentation/blocs/create_review/create_review_state.dart';
import 'package:eventy_customer/features/reviews/presentation/blocs/my_review/my_review_cubit.dart';
import 'package:eventy_customer/features/reviews/presentation/blocs/my_review/my_review_state.dart';
import 'package:eventy_customer/features/reviews/presentation/widgets/rating_stars_input.dart';
import 'package:eventy_customer/features/reviews/presentation/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveReviewPage extends StatelessWidget {
  final String bookingId;
  final String serviceName;

  const LeaveReviewPage({super.key, required this.bookingId, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<MyReviewCubit>()..load(bookingId)),
        BlocProvider(create: (_) => sl<CreateReviewCubit>()),
      ],
      child: _LeaveReviewView(bookingId: bookingId, serviceName: serviceName),
    );
  }
}

class _LeaveReviewView extends StatefulWidget {
  final String bookingId;
  final String serviceName;

  const _LeaveReviewView({required this.bookingId, required this.serviceName});

  @override
  State<_LeaveReviewView> createState() => _LeaveReviewViewState();
}

class _LeaveReviewViewState extends State<_LeaveReviewView> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) {
      showAppSnackBar(context, message: "Please select a rating", type: SnackBarType.warning);
      return;
    }
    if (_commentController.text.trim().length < 5) {
      showAppSnackBar(context, message: "Please write a short comment", type: SnackBarType.warning);
      return;
    }

    context.read<CreateReviewCubit>().submit(
          widget.bookingId,
          CreateReviewRequestModel(rating: _rating, comment: _commentController.text.trim()),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Leave a Review")),
      body: BlocListener<CreateReviewCubit, CreateReviewState>(
        listener: (context, state) {
          if (state is CreateReviewSuccess) {
            showAppSnackBar(context, message: "Thanks for your feedback!", type: SnackBarType.success);
            Navigator.pop(context, true);
          }
          if (state is CreateReviewError) {
            showAppSnackBar(context, message: state.message, type: SnackBarType.error);
          }
        },
        child: BlocBuilder<MyReviewCubit, MyReviewState>(
          builder: (context, myReviewState) {
            if (myReviewState is MyReviewLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (myReviewState is MyReviewError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(myReviewState.message, textAlign: TextAlign.center),
                ),
              );
            }

            final existing = (myReviewState as MyReviewLoaded).review;

            /// ⚠️ لا يوجد API لتعديل تقييم موجود — نعرضه للقراءة فقط
            if (existing != null) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.success.withOpacity(.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.success),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "You've already reviewed this booking",
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ReviewCard(review: existing),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    widget.serviceName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "How was your experience?",
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.6)),
                  ),
                  const SizedBox(height: 24),
                  RatingStarsInput(rating: _rating, onChanged: (v) => setState(() => _rating = v)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _commentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Share details about your experience...",
                      filled: true,
                      fillColor: theme.inputDecorationTheme.fillColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 26),
                  BlocBuilder<CreateReviewCubit, CreateReviewState>(
                    builder: (context, state) {
                      final isLoading = state is CreateReviewLoading;
                      return PrimaryButton(
                        title: isLoading ? "Submitting..." : "Submit Review",
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _submit,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}