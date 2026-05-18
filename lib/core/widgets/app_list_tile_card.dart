// import 'package:flutter/material.dart';

// class AppListCard extends StatelessWidget {
//   final Widget child;
//   final VoidCallback? onTap;

//   const AppListCard({
//     super.key,
//     required this.child,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: theme.inputDecorationTheme.fillColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class AppListCard extends StatelessWidget {

  final Widget child;

  final VoidCallback? onTap;

  const AppListCard({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      decoration: BoxDecoration(

        color: theme.cardColor,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(
            color:
                theme.brightness == Brightness.dark
                    ? Colors.black26
                    : Colors.black12,

            blurRadius: 8,

            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Material(

        color: Colors.transparent,

        borderRadius: BorderRadius.circular(18),

        child: InkWell(

          borderRadius: BorderRadius.circular(18),

          onTap: onTap,

          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}