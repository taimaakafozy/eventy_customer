import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/widgets/app_list_tile_card.dart';
import 'package:eventy_customer/core/widgets/primary_button.dart';
import 'package:eventy_customer/core/widgets/snackbar_helper.dart';
import 'package:eventy_customer/features/favorites/presentation/blocs/favorite_status/favorite_status_cubit.dart';
import 'package:eventy_customer/features/favorites/presentation/blocs/favorite_status/favorite_status_state.dart';
import 'package:eventy_customer/features/services/data/models/available_services_model/service_model.dart';
import 'package:eventy_customer/features/services/presentation/widgets/services/service_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceCard extends StatefulWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.service, required this.onTap});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool hovered = false;

  Future<void> _toggleFavorite(BuildContext context) async {
    try {
      await sl<FavoriteStatusCubit>().toggleFavorite(
        targetType: "SERVICE",
        targetId: widget.service.id,
      );
    } catch (e) {
      if (context.mounted) {
        showAppSnackBar(
          context,
          message: e.toString().replaceFirst('Exception: ', ''),
          type: SnackBarType.error,
        );
      }
    }
  }

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
                Stack(
                  children: [
                    ServiceImage(service: widget.service),

                    // / ⚠️ جديد: شعار مزوّد الخدمة — بادج دائري أعلى يسار الصورة
                    // if (widget.service.serviceLogo != null)
                    //   Positioned(
                    //     top: 16,
                    //     left: 16,
                    //     child: Container(
                    //       width: 46,
                    //       height: 46,
                    //       clipBehavior: Clip.antiAlias,
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         border: Border.all(color: Colors.white, width: 2),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.black.withOpacity(.15),
                    //             blurRadius: 6,
                    //           ),
                    //         ],
                    //       ),
                    //       child: Image.network(
                    //         widget.service.serviceLogo!,
                    //         fit: BoxFit.cover,
                    //         errorBuilder: (_, __, ___) =>
                    //             Container(color: Colors.white),
                    //       ),
                    //     ),
                    //   ),

                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.cardColor.withOpacity(.95),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.warning,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.service.rating.toStringAsFixed(1),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "(${widget.service.totalReviews})",
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
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
                    BlocSelector<
                      FavoriteStatusCubit,
                      FavoriteStatusState,
                      (bool, bool)
                    >(
                      bloc: sl<FavoriteStatusCubit>(),
                      selector: (state) {
                        final key = FavoriteStatusCubit.keyOf(
                          "SERVICE",
                          widget.service.id,
                        );
                        return (
                          state.favoriteKeys.contains(key),
                          state.loadingKeys.contains(key),
                        );
                      },
                      builder: (context, data) {
                        final (isFavorite, loading) = data;

                        return Material(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: loading
                                ? null
                                : () => _toggleFavorite(context),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite
                                          ? Colors.red
                                          : theme.primaryColor,
                                    ),
                            ),
                          ),
                        );
                      },
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
