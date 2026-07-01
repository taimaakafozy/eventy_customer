import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/widgets/app_list_tile_card.dart';
import 'package:eventy_customer/core/widgets/primary_button.dart';
import 'package:eventy_customer/features/services/data/models/available_services_model/service_model.dart';
import 'package:eventy_customer/features/services/presentation/widgets/services/service_image.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatefulWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.service, required this.onTap});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final location =
        widget.service.provider.user.locationName ??
        widget.service.locationName ??
        "Unknown location";

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),

      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: hovered ? 1.015 : 1,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),

            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(hovered ? .18 : .08),

                blurRadius: hovered ? 20 : 10,

                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: AppListCard(
            onTap: widget.onTap,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// IMAGE
                Stack(
                  children: [
                    ServiceImage(service: widget.service),

                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Text(
                          "ACTIVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 18,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              widget.service.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 4),

                            Text(
                              "(${widget.service.totalReviews})",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Text(
                  widget.service.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: theme.primaryColor,
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        location,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(
                      Icons.room_service_outlined,
                      size: 18,
                      color: theme.primaryColor,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      "${widget.service.subServices.length} Services",
                      style: theme.textTheme.bodySmall,
                    ),

                    const Spacer(),

                    if (widget.service.price != null)
                      Text(
                        "\$${widget.service.price}",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        title: "View Details",
                        onPressed: widget.onTap,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Material(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(14),

                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),

                        onTap: () {},

                        child: Padding(
                          padding: const EdgeInsets.all(12),

                          child: Icon(
                            Icons.favorite_border,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
