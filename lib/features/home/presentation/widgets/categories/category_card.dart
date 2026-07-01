import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:eventy_customer/core/utils/service_type_helper.dart';
import 'package:eventy_customer/features/services/data/models/service_type_model.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final ServiceTypeModel serviceType;
  final VoidCallback onTap;

  const CategoryCard({
  super.key,
  required this.serviceType,
  required this.onTap,
});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color circleColor =
        AppColors.primary.withOpacity(.10);

    final Color iconColor =
        AppColors.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.05 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 90,
                height: 108,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_hovered ? .08 : .04),
                      blurRadius: _hovered ? 18 : 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: circleColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
  ServiceTypeHelper.icon(
    widget.serviceType.name,
  ), size: 28, color: iconColor),
                    ),

                    const SizedBox(height: 14),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        ServiceTypeHelper.displayName(
  widget.serviceType.name,
),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
