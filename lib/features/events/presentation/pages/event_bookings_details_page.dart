import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/utils/booking_status_helper.dart';
import 'package:eventy_customer/core/utils/date_format_helper.dart';
import 'package:eventy_customer/core/widgets/app_confirmation_dialog.dart';
import 'package:eventy_customer/core/widgets/snackbar_helper.dart';
import 'package:eventy_customer/features/events/data/models/cancel_event_request_model.dart';
import 'package:eventy_customer/features/events/data/models/event_bookings_details_model.dart';
import 'package:eventy_customer/features/events/presentation/blocs/add_service_to_event/add_service_to_event_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/cancel_event/cancel_event_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/cancel_event/cancel_event_state.dart';
import 'package:eventy_customer/features/events/presentation/blocs/event_bookings_details/event_bookings_details_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/event_bookings_details/event_bookings_details_state.dart';
import 'package:eventy_customer/features/events/presentation/blocs/get_All_Events/Get_All_Events_Cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/quote_decision/quote_decision_cubit.dart';
import 'package:eventy_customer/features/events/presentation/blocs/quote_decision/quote_decision_state.dart';
import 'package:eventy_customer/features/events/presentation/widgets/booking_payment_qr.dart';
import 'package:eventy_customer/features/events/presentation/widgets/payment_method_sheet.dart';
import 'package:eventy_customer/features/reviews/presentation/pages/leave_review_page.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_details/service_details_cubit.dart';
import 'package:eventy_customer/features/services/presentation/pages/service_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventBookingsDetailsPage extends StatelessWidget {
  final String eventId;
  final String? addServiceId;

  const EventBookingsDetailsPage({
    super.key,
    required this.eventId,
    this.addServiceId,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("EVENT DETAILS PAGE");
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<EventBookingsDetailsCubit>(param1: eventId)..load(),
        ),
        BlocProvider(create: (_) => sl<QuoteDecisionCubit>(param1: eventId)),
        BlocProvider(create: (_) => sl<CancelEventCubit>()),
      ],
      child: _EventBookingsView(addServiceId: addServiceId),
    );
  }
}

class _EventBookingsView extends StatefulWidget {
  final String? addServiceId;
  const _EventBookingsView({this.addServiceId});

  @override
  State<_EventBookingsView> createState() => _EventBookingsViewState();
}

class _EventBookingsViewState extends State<_EventBookingsView> {
  /// bookingId -> true (accepted) / false (rejected) / غائب = غير محدد
  final Map<String, bool> _decisions = {};
  final Map<String, TextEditingController> _reasonControllers = {};

  TextEditingController _reasonControllerFor(String bookingId) {
    return _reasonControllers.putIfAbsent(
      bookingId,
      () => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final c in _reasonControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _toggleDecision(String bookingId, bool value) {
    setState(() {
      if (_decisions[bookingId] == value) {
        _decisions.remove(bookingId);
      } else {
        _decisions[bookingId] = value;
      }
    });
  }

  Future<void> _openAddService(
    BuildContext context,
    EventBookingsDetailsModel details,
  ) async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<ServiceDetailsCubit>()),
            BlocProvider(create: (_) => sl<AddServiceToEventCubit>()),
            BlocProvider(create: (_) => sl<CancelEventCubit>()),
          ],
          child: ServiceDetailsPage(
            serviceId: widget.addServiceId!,
            selectable: true,
            addToEventId: details.id,
            addToEventName: details.name,
            eventDate: details.eventDate,
            eventStartTime: details.eventStartTime,
            eventEndTime: details.eventEndTime,
            eventGuests: details.numberOfGuests,
          ),
        ),
      ),
    );

    if (added == true && context.mounted) {
      context.read<EventBookingsDetailsCubit>().load();
    }
  }

  Future<void> _showCancelDialog(String eventId) async {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AppConfirmationDialog(
        title: "Cancel Event",
        message: "Are you sure?",
        confirmText: "Cancel Event",
        icon: Icons.cancel_rounded,
        iconColor: AppColors.error,
        confirmColor: AppColors.error,
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: "Reason",
            hintText: "Cancellation reason",
          ),
        ),
        onConfirm: () {
          context.read<CancelEventCubit>().cancelEvent(
            eventId: eventId,
            reason: CancelEventRequestModel(
              reason: reasonController.text.trim(),
            ),
          );
        },
      ),
    );
  }

  Future<void> _rejectAll(EventBookingsDetailsModel details) async {
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Reject All Offers?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("This will reject all pending quotes for this event."),
            const SizedBox(height: 14),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: "Reason (optional)"),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text("Cancel"),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text("Reject All"),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    context.read<QuoteDecisionCubit>().submit(
      acceptedBookingIds: const [],
      rejectedBookingIds: details.quoteSentBookings.map((b) => b.id).toList(),
      rejectionReason: reasonController.text.trim().isEmpty
          ? null
          : reasonController.text.trim(),
    );
  }

  Future<void> _confirmSelection(EventBookingsDetailsModel details) async {
    final acceptedIds = _decisions.entries
        .where((e) => e.value == true)
        .map((e) => e.key)
        .toList();
    final rejectedIds = _decisions.entries
        .where((e) => e.value == false)
        .map((e) => e.key)
        .toList();

    if (acceptedIds.isEmpty && rejectedIds.isEmpty) {
      showAppSnackBar(
        context,
        message: "Please select at least one service",
        type: SnackBarType.warning,
      );
      return;
    }

    String? method;

    if (acceptedIds.isNotEmpty) {
      final totalAccepted = details.quoteSentBookings
          .where((b) => acceptedIds.contains(b.id))
          .fold(0.0, (sum, b) => sum + b.displayAmount);

      method = await PaymentMethodSheet.show(
        context,
        totalAccepted: totalAccepted,
      );
      if (method == null) return;
    }

    if (!mounted) return;

    /// ⚠️ الـ API تدعم رسالة سبب واحدة لكل الحجوزات المرفوضة بالطلب الواحد،
    /// فندمج كل الأسباب الفردية (لو المستخدم كتب أكثر من واحد) بفاصلة
    String? combinedReason;
    if (rejectedIds.isNotEmpty) {
      final reasons = rejectedIds
          .map((id) => _reasonControllers[id]?.text.trim() ?? '')
          .where((text) => text.isNotEmpty)
          .toList();
      if (reasons.isNotEmpty) combinedReason = reasons.join('; ');
    }

    context.read<QuoteDecisionCubit>().submit(
      acceptedBookingIds: acceptedIds,
      method: method,
      rejectedBookingIds: rejectedIds,
      rejectionReason: combinedReason,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: widget.addServiceId == null
          ? null
          : BlocBuilder<EventBookingsDetailsCubit, EventBookingsDetailsState>(
              builder: (context, state) {
                if (state is! EventBookingsDetailsLoaded)
                  return const SizedBox();
                return FloatingActionButton.extended(
                  onPressed: () => _openAddService(context, state.details),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Add Service"),
                );
              },
            ),
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Event Bookings")),

      body: MultiBlocListener(
        listeners: [
          BlocListener<QuoteDecisionCubit, QuoteDecisionState>(
            listener: (context, state) {
              if (state is QuoteDecisionSuccess) {
                setState(() {
                  _decisions.clear();
                  _reasonControllers.clear();
                });

                context.read<EventBookingsDetailsCubit>().load();

                showAppSnackBar(
                  context,
                  message: state.message,
                  type: SnackBarType.success,
                );

                context.read<QuoteDecisionCubit>().reset();
              }

              if (state is QuoteDecisionError) {
                showAppSnackBar(
                  context,
                  message: state.message,
                  type: SnackBarType.error,
                );

                context.read<QuoteDecisionCubit>().reset();
              }
            },
          ),

          BlocListener<CancelEventCubit, CancelEventState>(
            listener: (context, state) {
              if (state is CancelEventSuccess) {
                showAppSnackBar(
                  context,
                  message: state.message,
                  type: SnackBarType.success,
                );

                sl<GetAllEventsCubit>().refresh();

                context.read<EventBookingsDetailsCubit>().load();

                context.read<CancelEventCubit>().reset();
              }

              if (state is CancelEventError) {
                showAppSnackBar(
                  context,
                  message: state.message,
                  type: SnackBarType.error,
                );

                context.read<CancelEventCubit>().reset();
              }
            },
          ),
        ],

        child: BlocBuilder<EventBookingsDetailsCubit, EventBookingsDetailsState>(
          builder: (context, state) {
            if (state is EventBookingsDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EventBookingsDetailsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message, textAlign: TextAlign.center),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<EventBookingsDetailsCubit>().load(),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
              );
            }

            final details = (state as EventBookingsDetailsLoaded).details;
            final canCancel =
                details.status != "CANCELLED" && details.status != "COMPLETED";
            return RefreshIndicator(
              onRefresh: () => context.read<EventBookingsDetailsCubit>().load(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          details.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      if (canCancel)
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.error,
                          ),
                          onPressed: () {
                            _showCancelDialog(details.id);
                          },
                          icon: const Icon(Icons.cancel_outlined, size: 18),
                          label: const Text("Cancel"),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "${DateFormatHelper.toDisplayDate(details.eventDate)} · ${details.eventStartTime} - ${details.eventEndTime}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(.6),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (details.hasAnyDecisionPending)
                    Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.warning.withOpacity(.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.timer_rounded,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "You have new price offers. Please respond within 24 hours or the event will be cancelled.",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (details.pendingBookings.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(.06),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.hourglass_top_rounded,
                            color: theme.primaryColor,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Waiting for providers to send you their pricing.",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  .7,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ...details.bookings.map(
                    (b) => _BookingCard(
                      booking: b,
                      decision: _decisions[b.id],
                      onAccept: b.status.toUpperCase() == "QUOTE_SENT"
                          ? () => _toggleDecision(b.id, true)
                          : null,
                      onReject: b.status.toUpperCase() == "QUOTE_SENT"
                          ? () => _toggleDecision(b.id, false)
                          : null,
                      reasonController: _decisions[b.id] == false
                          ? _reasonControllerFor(b.id)
                          : null,
                      onLeaveReview: b.status.toUpperCase() == "COMPLETED"
                          ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LeaveReviewPage(
                                  bookingId: b.id,
                                  serviceName: b.provider.businessName,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),

      bottomNavigationBar:
          BlocBuilder<EventBookingsDetailsCubit, EventBookingsDetailsState>(
            builder: (context, state) {
              if (state is! EventBookingsDetailsLoaded ||
                  !state.details.hasAnyDecisionPending) {
                return const SizedBox();
              }

              return BlocBuilder<QuoteDecisionCubit, QuoteDecisionState>(
                builder: (context, decisionState) {
                  final isSubmitting = decisionState is QuoteDecisionSubmitting;

                  return SafeArea(
                    minimum: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isSubmitting
                                ? null
                                : () => _rejectAll(state.details),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                            ),
                            child: const Text("Reject All"),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () => _confirmSelection(state.details),
                            child: isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Confirm Selection"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingDetailModel booking;
  final bool? decision;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  /// ⚠️ جديد: يظهر فقط عند تحديد "رفض" لهذا الحجز تحديدًا
  final TextEditingController? reasonController;
  final VoidCallback? onLeaveReview;

  const _BookingCard({
    required this.booking,
    this.decision,
    this.onAccept,
    this.onReject,
    this.reasonController,
    this.onLeaveReview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = BookingStatusHelper.color(booking.status);
    final isActionable = onAccept != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: decision == true
              ? AppColors.success
              : decision == false
              ? AppColors.error
              : theme.dividerColor.withOpacity(.2),
          width: decision != null ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: booking.service.serviceLogo != null
                    ? Image.network(
                        booking.service.serviceLogo!,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.room_service_rounded,
                        color: theme.primaryColor,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.provider.businessName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      booking.service.serviceTypeName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(.55),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.10),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(.35)),
                ),
                child: Text(
                  BookingStatusHelper.displayName(booking.status),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.5,
                  ),
                ),
              ),
            ],
          ),
          if (booking.items.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...booking.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${item.name} × ${item.quantity}",
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      "\$${item.displayTotal.toStringAsFixed(0)}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (booking.discount != null)
                    Text(
                      "\$${booking.totalAmount.toStringAsFixed(0)}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(.4),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    "\$${booking.displayAmount.toStringAsFixed(0)}",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (booking.discount != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Saved \$${booking.discount!.amount.toStringAsFixed(0)} (${booking.discount!.percentOff.toStringAsFixed(0)}% off)",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                      fontSize: 10.5,
                    ),
                  ),
                ),
              ),
            ),
          if (isActionable) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: decision == false ? Colors.white : AppColors.error,
                    ),
                    label: const Text("Reject"),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: decision == false
                          ? AppColors.error
                          : null,
                      foregroundColor: decision == false
                          ? Colors.white
                          : AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onAccept,
                    icon: Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: decision == true
                          ? Colors.white
                          : AppColors.success,
                    ),
                    label: const Text("Accept"),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: decision == true
                          ? AppColors.success
                          : null,
                      foregroundColor: decision == true
                          ? Colors.white
                          : AppColors.success,
                      side: const BorderSide(color: AppColors.success),
                    ),
                  ),
                ),
              ],
            ),

            /// ⚠️ جديد: حقل سبب اختياري يظهر فقط عند اختيار "Reject" لهذا الحجز
            if (decision == false && reasonController != null) ...[
              const SizedBox(height: 10),
              TextField(
                controller: reasonController,
                maxLines: 2,
                style: theme.textTheme.bodySmall,
                decoration: InputDecoration(
                  hintText: "Reason for rejecting (optional)",
                  hintStyle: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(.4),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: AppColors.error.withOpacity(.04),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.error.withOpacity(.2),
                    ),
                  ),
                ),
              ),
            ],
          ],
          if (booking.status.toUpperCase() == "CONFIRMED" &&
              booking.payment != null)
            BookingPaymentQr(payment: booking.payment!),

          if (booking.status.toUpperCase() == "COMPLETED" &&
              onLeaveReview != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onLeaveReview,
                icon: const Icon(Icons.star_border_rounded, size: 18),
                label: const Text("Leave a Review"),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
