import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PaymentMethodSheet extends StatefulWidget {
  final double totalAccepted;

  const PaymentMethodSheet({super.key, required this.totalAccepted});

  static Future<String?> show(BuildContext context, {required double totalAccepted}) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PaymentMethodSheet(totalAccepted: totalAccepted),
    );
  }

  @override
  State<PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<PaymentMethodSheet> {
  String _selected = "CASH";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choose Payment Method",
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            "Total for accepted services: \$${widget.totalAccepted.toStringAsFixed(0)}",
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.6)),
          ),
          const SizedBox(height: 20),
          _MethodTile(
            title: "Cash on Delivery",
            subtitle: "Pay each provider in person and confirm with a QR code",
            icon: Icons.payments_rounded,
            selected: _selected == "CASH",
            onTap: () => setState(() => _selected = "CASH"),
          ),
          const SizedBox(height: 10),
          _MethodTile(
            title: "Bank Transfer",
            subtitle: "Coming soon",
            icon: Icons.account_balance_rounded,
            selected: false,
            enabled: false,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _selected),
              child: const Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _MethodTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: enabled ? 1 : .5,
      child: Material(
        color: selected ? theme.primaryColor.withOpacity(.08) : theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? onTap : null,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selected ? theme.primaryColor : theme.dividerColor.withOpacity(.3)),
            ),
            child: Row(
              children: [
                Icon(icon, color: theme.primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                      Text(subtitle,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.55))),
                    ],
                  ),
                ),
                if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.success),
              ],
            ),
          ),
        ),
      ),
    );
  }
}