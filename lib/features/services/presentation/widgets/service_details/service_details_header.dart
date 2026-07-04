import 'package:eventy_customer/core/utils/service_type_helper.dart';
import 'package:eventy_customer/features/services/data/models/service_details_model.dart';
import 'package:eventy_customer/features/services/presentation/widgets/services/service_placeholder.dart';
import 'package:flutter/material.dart';

class ServiceDetailsHeader extends StatelessWidget {
  final ServiceDetailsModel service;

  const ServiceDetailsHeader({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(.35),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 17,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: service.id,
          child: service.hasImages
              ? Image.network(
                  service.mainImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => ServicePlaceholder(
                    type: ServiceTypeHelper.displayName(
                      service.serviceType.name,
                    ),
                  ),
                )
              : ServicePlaceholder(
                  type: ServiceTypeHelper.displayName(
                    service.serviceType.name,
                  ),
                ),
        ),
      ),
    );
  }
}