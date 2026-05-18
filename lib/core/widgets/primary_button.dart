import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {

  final String title;

  final VoidCallback? onPressed;

  final bool isLoading;

  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(

        onPressed: isLoading ? null : onPressed,

        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  if (icon != null) ...[
                    Icon(icon),
                    const SizedBox(width: 8),
                  ],

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}