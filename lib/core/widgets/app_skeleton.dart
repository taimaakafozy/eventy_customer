import 'package:flutter/material.dart';

class AppSkeleton extends StatelessWidget {

  const AppSkeleton({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final baseColor =
        theme.brightness == Brightness.dark
            ? Colors.white10
            : Colors.black12;

    return Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: baseColor,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Container(
                  height: 14,
                  width: 120,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius:
                        BorderRadius.circular(6),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  height: 12,
                  width: 80,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius:
                        BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}