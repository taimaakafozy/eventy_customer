import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/features/services/data/models/available_services_model/service_model.dart';
import 'package:flutter/material.dart';

import 'service_placeholder.dart';

class ServiceImage extends StatelessWidget {
  final ServiceModel service;

  const ServiceImage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool hasImage =
        service.files.isNotEmpty && service.files.first.url.isNotEmpty;

    return Hero(
      tag: service.id,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 220,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// Image / Placeholder
              if (hasImage)
                Image.network(
                  service.files.first.url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return ServicePlaceholder(type: service.serviceType.name);
                  },
                )
              else
                ServicePlaceholder(type: service.serviceType.name),

              /// Dark Overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(.08),
                        Colors.black.withOpacity(.55),
                      ],
                    ),
                  ),
                ),
              ),

              /// Service Type Badge
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(.92),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    service.serviceType.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              /// Rating Badge
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: theme.cardColor.withOpacity(.95),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: AppColors.gold,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        service.rating.toStringAsFixed(1),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Bottom Info
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.provider.businessName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                          size: 16,
                        ),

                        const SizedBox(width: 4),

                        Expanded(
                          child: Text(
                            service.provider.user.locationName ??
                                "Location not available",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
