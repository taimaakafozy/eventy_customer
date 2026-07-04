import 'package:eventy_customer/core/di/service_locator.dart';
import 'package:eventy_customer/core/utils/service_type_helper.dart';
import 'package:eventy_customer/features/services/data/models/service_details_model.dart';
import 'package:eventy_customer/features/services/presentation/blocs/service_details/service_details_cubit.dart';
import 'package:eventy_customer/features/services/presentation/pages/service_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackageServicesSection extends StatelessWidget {
  final List<PackageServiceModel> services;

  const PackageServicesSection({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: services.map((s) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withOpacity(.15)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: s.logo != null
                    ? Image.network(
                        s.logo!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          ServiceTypeHelper.icon(s.serviceTypeName),
                          color: theme.primaryColor,
                        ),
                      )
                    : Icon(
                        ServiceTypeHelper.icon(s.serviceTypeName),
                        color: theme.primaryColor,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.name,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      ServiceTypeHelper.displayName(s.serviceTypeName),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(.55),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => sl<ServiceDetailsCubit>(),
                        child: ServiceDetailsPage(serviceId: s.id),
                      ),
                    ),
                  );
                },
                child: const Text("View"),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}