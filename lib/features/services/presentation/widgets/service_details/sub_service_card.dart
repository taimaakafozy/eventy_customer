import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/widgets/primary_quantity_stepper.dart';
import 'package:eventy_customer/features/services/data/models/service_details_model.dart';
import 'package:eventy_customer/features/services/presentation/widgets/service_details/sub_service_media_viewer.dart';
import 'package:flutter/material.dart';

class SubServiceCard extends StatelessWidget {
  final SubServiceModel subService;

  final bool selectable;
  final bool isSelected;
  final int quantity;

  /// ⚠️ جديد: تعطيل التحديد (مثلاً عدم تطابق وقت المناسبة) دون إخفاء البطاقة
  final bool enabled;

  final VoidCallback? onToggle;
  final ValueChanged<int>? onQuantityChanged;

  const SubServiceCard({
    super.key,
    required this.subService,
    this.selectable = false,
    this.isSelected = false,
    this.quantity = 1,
    this.enabled = true,
    this.onToggle,
    this.onQuantityChanged,
  });

  void _openViewer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubServiceMediaViewer(media: subService.media, title: subService.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = subService.media;
    final hasMedia = media.isNotEmpty;
    final firstItem = hasMedia ? media.first : null;
    final canSelect = selectable && subService.isAvailable && enabled;

    return Opacity(
      opacity: selectable && !enabled ? 0.5 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? theme.primaryColor : theme.dividerColor.withOpacity(.15),
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (canSelect)
                  Padding(
                    padding: const EdgeInsets.only(right: 8, top: 2),
                    child: GestureDetector(
                      onTap: onToggle,
                      child: Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        color: isSelected ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(.3),
                        size: 22,
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: hasMedia ? () => _openViewer(context) : null,
                  child: Container(
                    width: 52,
                    height: 52,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: hasMedia
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              firstItem!.type == ServiceFileType.video
                                  ? Container(
                                      color: Colors.black87,
                                      child: const Icon(Icons.play_circle_fill_rounded,
                                          color: Colors.white, size: 22),
                                    )
                                  : Image.network(
                                      firstItem.url,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          Icon(Icons.room_service_rounded, color: theme.primaryColor),
                                    ),
                              if (media.length > 1)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.65),
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.collections_rounded, color: Colors.white, size: 9),
                                        const SizedBox(width: 2),
                                        Text("${media.length}",
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : Icon(Icons.room_service_rounded, color: theme.primaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subService.name,
                          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                      if (subService.description.trim().isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          subService.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.6)),
                        ),
                      ],
                      const SizedBox(height: 6),
                      if (!subService.isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("Unavailable",
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.error, fontWeight: FontWeight.w700, fontSize: 10)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("\$${subService.pricePerUnit.toStringAsFixed(2)}",
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: AppColors.gold, fontWeight: FontWeight.w800)),
                    Text("/ ${subService.unitType.toLowerCase()}",
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(.5))),
                  ],
                ),
              ],
            ),
            if (canSelect && isSelected) ...[
              const SizedBox(height: 12),
              Divider(height: 1, color: theme.dividerColor.withOpacity(.3)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text("Quantity", style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  PrimaryQuantityStepper(
                    value: quantity,
                    min: 1,
                    max: subService.dailyCapacity > 0 ? subService.dailyCapacity : null,
                    onChanged: onQuantityChanged ?? (_) {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Total: \$${(subService.pricePerUnit * quantity).toStringAsFixed(2)}",
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w700, color: theme.primaryColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}