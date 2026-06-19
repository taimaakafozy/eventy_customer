import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Two-step horizontal indicator with animated transitions.
/// Active step glows with primary shadow.
/// Completed step shows gold connector line.
class RegisterStepIndicator extends StatelessWidget {
  final int currentStep;

  const RegisterStepIndicator({super.key, required this.currentStep});

  static const _labels = ['Personal Info', 'Profile Setup'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_labels.length, (index) {
        final isDone   = index < currentStep;
        final isActive = index == currentStep;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Dot ────────────────────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  width:  isActive ? 32 : 28,
                  height: isActive ? 32 : 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone || isActive
                        ? AppColors.primary
                        : AppColors.softPurple,
                    border: isActive
                        ? Border.all(
                            color: AppColors.gold.withOpacity(0.6),
                            width: 2.5,
                          )
                        : null,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 15)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isActive
                                  ? Colors.white
                                  : AppColors.primary.withOpacity(0.5),
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 4),

                // ── Label ───────────────────────────────────────────────────
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.4),
                  ),
                  child: Text(_labels[index]),
                ),
              ],
            ),

            // ── Connector line ──────────────────────────────────────────────
            if (index < _labels.length - 1)
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                width:  60,
                height: 2,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isDone
                      ? AppColors.gold.withOpacity(0.75)
                      : AppColors.softPurple,
                ),
              ),
          ],
        );
      }),
    );
  }
}