import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/utils/date_format_helper.dart';
import 'package:eventy_customer/features/reviews/data/models/review_model.dart';
import 'package:flutter/material.dart';

import 'rating_stars_input.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = review.customer?.fullName ?? "Anonymous";
    final initials = name.trim().isEmpty
        ? "?"
        : name.trim().split(RegExp(r'\s+')).map((e) => e[0]).take(2).join().toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.primaryColor.withOpacity(.15),
                backgroundImage: review.customer?.profileImage != null
                    ? NetworkImage(review.customer!.profileImage!)
                    : null,
                child: review.customer?.profileImage == null
                    ? Text(initials,
                        style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 13))
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                      DateFormatHelper.toDisplayDate(review.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.5)),
                    ),
                  ],
                ),
              ),
              RatingStarsDisplay(rating: review.rating, size: 15),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.comment, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
          if (review.providerReply != null && review.providerReply!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.reply_rounded, size: 14, color: theme.primaryColor),
                      const SizedBox(width: 6),
                      Text("Provider Response",
                          style: theme.textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w700, color: theme.primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(review.providerReply!, style: theme.textTheme.bodySmall?.copyWith(height: 1.5)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}