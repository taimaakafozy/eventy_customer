import 'package:flutter/material.dart';

class AppContentContainer extends StatelessWidget {

  final Widget child;

  final EdgeInsetsGeometry? padding;

  final double borderRadius;

  final double? maxHeight;

  const AppContentContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Container(

      constraints: maxHeight != null
          ? BoxConstraints(maxHeight: maxHeight!)
          : null,

      width: double.infinity,

      padding:
          padding ??
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),

      decoration: BoxDecoration(

        color: theme.cardColor,

        borderRadius:
            BorderRadius.circular(borderRadius),

        boxShadow: [

          BoxShadow(
            color:
                theme.brightness == Brightness.dark
                    ? Colors.black26
                    : Colors.black12,

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: child,
    );
  }
}