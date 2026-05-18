// import 'package:flutter/material.dart';

// class FiltersChip extends StatelessWidget {

//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   const FiltersChip({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {

//     final theme = Theme.of(context);

//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 10,
//         ),
//         decoration: BoxDecoration(
//           color: selected
//               ? theme.primaryColor
//               : theme.inputDecorationTheme.fillColor,
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: selected
//                 ? Colors.white
//                 : theme.textTheme.bodyMedium?.color,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class FiltersChip extends StatelessWidget {

  final String label;

  final bool selected;

  final VoidCallback onTap;

  const FiltersChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return GestureDetector(

      onTap: onTap,

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 220),

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 11,
        ),

        decoration: BoxDecoration(

          color: selected
              ? theme.primaryColor
              : theme.cardColor,

          borderRadius: BorderRadius.circular(30),

          border: Border.all(
            color: selected
                ? theme.primaryColor
                : theme.dividerColor,
          ),
        ),

        child: Text(

          label,

          style: TextStyle(

            color: selected
                ? Colors.white
                : theme.textTheme.bodyMedium?.color,

            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}