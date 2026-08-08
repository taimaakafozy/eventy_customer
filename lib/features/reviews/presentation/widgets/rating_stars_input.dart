import 'package:flutter/material.dart';

/// مؤشر نجوم تفاعلي لاختيار التقييم (1-5) عند إنشاء تقييم جديد
class RatingStarsInput extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;
  final double size;

  const RatingStarsInput({super.key, required this.rating, required this.onChanged, this.size = 38});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final filled = starValue <= rating;

        return GestureDetector(
          onTap: () => onChanged(starValue),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_border_rounded,
              color: Colors.amber,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}

/// عرض نجوم غير تفاعلي — لعرض تقييم موجود
class RatingStarsDisplay extends StatelessWidget {
  final int rating;
  final double size;

  const RatingStarsDisplay({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star_rounded : Icons.star_border_rounded,
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }
}