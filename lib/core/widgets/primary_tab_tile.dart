import 'package:flutter/material.dart';

class PrimaryTabTile extends StatelessWidget {
  final String title;
  final String?subtitle;
  final String?subtitle2;

  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? child;
  final bool isExpanded;
  final bool showArrow;

  const PrimaryTabTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.trailing,
    this.child,
    this.isExpanded = false,
    this.showArrow = true,
     this. subtitle,
    this.subtitle2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            splashColor: theme.primaryColor.withOpacity(0.08),
            highlightColor: theme.primaryColor.withOpacity(0.04),
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(icon, color: theme.primaryColor),
                      const SizedBox(width: 16),
                      Expanded(
                        // child: Text(
                        //   title,
                        //   style: theme.textTheme.titleMedium?.copyWith(
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            if (subtitle != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                subtitle!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  // color: Colors.grey[600],
                                ),
                              ),
                            ],
                            if (subtitle2 != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                subtitle2!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  // color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (trailing != null) trailing!,
                      if (showArrow && trailing == null)
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.expand_more,
                            color: theme.primaryColor,
                          ),
                        ),
                    ],
                  ),

                  /// Accordion Content
                  if (child != null)
                    ClipRect(
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: isExpanded
                              ? const BoxConstraints()
                              : const BoxConstraints(maxHeight: 0),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: child,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
