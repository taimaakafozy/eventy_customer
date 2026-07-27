import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/utils/complaint_status_helper.dart';
import 'package:eventy_customer/features/complaints/presentation/blocs/complaint_details/complaint_details_cubit.dart';
import 'package:eventy_customer/features/complaints/presentation/blocs/complaint_details/complaint_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintDetailsPage extends StatelessWidget {
  final String complaintId;

  const ComplaintDetailsPage({super.key, required this.complaintId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ComplaintDetailsCubit>()..loadDetails(complaintId),
      child: Scaffold(
        appBar: AppBar(title: const Text("Complaint Details")),
        body: BlocBuilder<ComplaintDetailsCubit, ComplaintDetailsState>(
          builder: (context, state) {
            final theme = Theme.of(context);

            if (state is ComplaintDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ComplaintDetailsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              );
            }

            final complaint = (state as ComplaintDetailsLoaded).complaint;
            final statusColor = ComplaintStatusHelper.color(complaint.status);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(ComplaintStatusHelper.icon(complaint.status), size: 15, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          ComplaintStatusHelper.displayName(complaint.status),
                          style: theme.textTheme.bodySmall?.copyWith(color: statusColor, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(complaint.subject, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    "Submitted on ${complaint.createdAt.year}-${complaint.createdAt.month.toString().padLeft(2, '0')}-${complaint.createdAt.day.toString().padLeft(2, '0')}",
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.5)),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 14, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description",
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                        Text(complaint.description, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
                      ],
                    ),
                  ),
                  if (complaint.adminReply != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.success.withOpacity(.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.reply_rounded, color: AppColors.success, size: 18),
                              const SizedBox(width: 8),
                              Text("Response from our team",
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w700, color: AppColors.success)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(complaint.adminReply!, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
                          if (complaint.resolvedAt != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              "Resolved on ${complaint.resolvedAt!.year}-${complaint.resolvedAt!.month.toString().padLeft(2, '0')}-${complaint.resolvedAt!.day.toString().padLeft(2, '0')}",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(.5),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(.06),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.hourglass_top_rounded, color: theme.primaryColor, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Our team is reviewing your complaint and will respond soon.",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}