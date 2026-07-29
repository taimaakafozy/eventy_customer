import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/features/events/data/models/event_bookings_details_model.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingPaymentQr extends StatelessWidget {
  final BookingPaymentModel payment;

  const BookingPaymentQr({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPaid = payment.status.toUpperCase() == "PAID";

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.primaryColor.withOpacity(.2)),
      ),
      child: Column(
        children: [
          if (isPaid)
            Column(
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 40),
                const SizedBox(height: 8),
                Text("Payment Confirmed",
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.success, fontWeight: FontWeight.w700)),
              ],
            )
          else ...[
            QrImageView(data: payment.id, size: 140, backgroundColor: Colors.white),
            const SizedBox(height: 10),
            Text(
              "Please go to the provider's location and pay in cash.\nAsk them to scan this code to confirm your booking within 2 days.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.65)),
            ),
          ],
        ],
      ),
    );
  }
}