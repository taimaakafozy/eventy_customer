import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/utils/service_type_helper.dart';
import 'package:flutter/material.dart';

class ServicePlaceholder extends StatelessWidget {
  final String type;

  const ServicePlaceholder({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.primaryColor, AppColors.gold],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -35,
            right: -35,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -45,
            left: -45,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(.25)),
                  ),
                  child: Icon(
                    ServiceTypeHelper.icon(type),
                    size: 42,
                    color: Colors.white,
                  ),
                ),
                Text(
                  ServiceTypeHelper.displayName(type),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
