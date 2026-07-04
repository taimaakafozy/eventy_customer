import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/features/services/data/models/service_details_model.dart';
import 'package:eventy_customer/features/services/presentation/widgets/service_details/sub_service_media_viewer.dart';
import 'package:flutter/material.dart';

class SubServiceCard extends StatelessWidget {
  final SubServiceModel subService;

  const SubServiceCard({super.key, required this.subService});

  void _openViewer(BuildContext context, {int initialIndex = 0}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubServiceMediaViewer(
          media: subService.media,
          title: subService.name,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = subService.media;
    final hasMedia = media.isNotEmpty;
    final firstItem = hasMedia ? media.first : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor.withOpacity(.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                                child: const Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              )
                            : Image.network(
                                firstItem.url,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.room_service_rounded,
                                  color: theme.primaryColor,
                                ),
                              ),

                        /// شارة تدل على وجود أكثر من عنصر ميديا
                        if (media.length > 1)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.65),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.collections_rounded,
                                    color: Colors.white,
                                    size: 9,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    "${media.length}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
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
                Text(
                  subService.name,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (subService.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    subService.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(.6),
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                if (!subService.isAvailable)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Unavailable",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${subService.pricePerUnit.toStringAsFixed(2)}",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "/ ${subService.unitType.toLowerCase()}",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}