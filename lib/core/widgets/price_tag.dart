import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// ودجت موحّد لعرض السعر بكل أنحاء التطبيق — يعرض السعر الأصلي مشطوبًا
/// + السعر بعد الخصم + بادج نسبة الخصم، تلقائيًا فقط عند وجود خصم فعلي.
/// استخدام مركزي واحد يمنع تكرار نفس الشرط (originalPrice != finalPrice) بعشرات الأماكن.
class PriceTag extends StatelessWidget {
  final double? originalPrice;
  final double? finalPrice;
  final double? percentOff;
  final String? suffix; // مثال: "/pp" أو "/item"
  final double fontSize;
  final Color? color;
  final MainAxisAlignment alignment;

  const PriceTag({
    super.key,
    required this.originalPrice,
    required this.finalPrice,
    this.percentOff,
    this.suffix,
    this.fontSize = 15,
    this.color,
    this.alignment = MainAxisAlignment.start,
  });

  bool get hasDiscount =>
      originalPrice != null && finalPrice != null && finalPrice! < originalPrice!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceColor = color ?? AppColors.gold;

    if (finalPrice == null) return const SizedBox.shrink();

    if (!hasDiscount) {
      return Text(
        "\$${finalPrice!.toStringAsFixed(finalPrice! % 1 == 0 ? 0 : 2)}${suffix ?? ''}",
        style: theme.textTheme.bodyLarge?.copyWith(color: priceColor, fontWeight: FontWeight.w800, fontSize: fontSize),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: [
        Text(
          "\$${originalPrice!.toStringAsFixed(originalPrice! % 1 == 0 ? 0 : 2)}",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(.4),
            decoration: TextDecoration.lineThrough,
            fontSize: fontSize - 3,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          "\$${finalPrice!.toStringAsFixed(finalPrice! % 1 == 0 ? 0 : 2)}${suffix ?? ''}",
          style: theme.textTheme.bodyLarge?.copyWith(color: priceColor, fontWeight: FontWeight.w800, fontSize: fontSize),
        ),
        if (percentOff != null) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "-${percentOff!.toStringAsFixed(0)}%",
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w800,
                fontSize: 10.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// شارة صغيرة "خصم x%" — تُستخدم فوق صور الكاردات (مثل بادج ACTIVE)
class DiscountBadge extends StatelessWidget {
  final double percentOff;
  const DiscountBadge({super.key, required this.percentOff});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.error, Color(0xFFFF7A59)]),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [BoxShadow(color: AppColors.error.withOpacity(.35), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_offer_rounded, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            "${percentOff.toStringAsFixed(0)}% OFF",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ],
      ),
    );
  }
}