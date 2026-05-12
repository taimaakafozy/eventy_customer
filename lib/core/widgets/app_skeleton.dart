import 'package:flutter/material.dart';

class AppSkeleton extends StatelessWidget {
  const AppSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          /// avatar placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .copyWith(
                    cardColor: const Color.fromARGB(
                      255,
                      53,
                      53,
                      53,
                    ).withOpacity(0.3),
                  )
                  .cardColor,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 12),

          /// text placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 120,
                  color: Theme.of(context)
                      .copyWith(
                        cardColor: const Color.fromARGB(
                          255,
                          53,
                          53,
                          53,
                        ).withOpacity(0.3),
                      )
                      .cardColor,
                ),

                const SizedBox(height: 8),

                Container(
                  height: 12,
                  width: 80,
                  color: Theme.of(context)
                      .copyWith(
                        cardColor: const Color.fromARGB(
                          255,
                          53,
                          53,
                          53,
                        ).withOpacity(0.3),
                      )
                      .cardColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
