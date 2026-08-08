import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/widgets/emptyview_data.dart';
import 'package:eventy_customer/features/reviews/presentation/blocs/service_reviews/service_reviews_cubit.dart';
import 'package:eventy_customer/features/reviews/presentation/blocs/service_reviews/service_reviews_state.dart';
import 'package:eventy_customer/features/reviews/presentation/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewsSection extends StatelessWidget {
  final String serviceId;
  final double averageRating;
  final int totalReviews;

  const ReviewsSection({
    super.key,
    required this.serviceId,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ServiceReviewsCubit>()..load(serviceId),
      child: _ReviewsSectionView(averageRating: averageRating, totalReviews: totalReviews),
    );
  }
}

class _ReviewsSectionView extends StatelessWidget {
  final double averageRating;
  final int totalReviews;

  const _ReviewsSectionView({required this.averageRating, required this.totalReviews});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Reviews", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            if (totalReviews > 0) ...[
              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 3),
              Text(
                "${averageRating.toStringAsFixed(1)} ($totalReviews)",
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<ServiceReviewsCubit, ServiceReviewsState>(
          builder: (context, state) {
            if (state is ServiceReviewsLoading) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is ServiceReviewsError) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(state.message, style: theme.textTheme.bodySmall),
              );
            }

            final loaded = state as ServiceReviewsLoaded;

            if (loaded.items.isEmpty) {
              return const EmptyView(
                title: "No reviews yet",
                message: "Be the first to share your experience with this service",
                icon: Icons.rate_review_outlined,
              );
            }

            return Column(
              children: [
                ...loaded.items.map((r) => ReviewCard(review: r)),
                if (!loaded.hasReachedEnd)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 10),
                    child: Center(
                      child: loaded.isLoadingMore
                          ? const CircularProgressIndicator()
                          : OutlinedButton(
                              onPressed: () => context.read<ServiceReviewsCubit>().loadMore(),
                              child: const Text("Show More Reviews"),
                            ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}