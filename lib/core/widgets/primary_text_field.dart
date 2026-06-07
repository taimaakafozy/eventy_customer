import 'package:eventy_customer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PrimaryTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final String? Function(String?)? validator;
  final int maxLines;
  final Widget? suffix;

  const PrimaryTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.validator,
    this.maxLines = 1,
    this.suffix,
  });

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  final FocusNode _focus = FocusNode();

  bool _obscure = true;

  @override
  void initState() {
    super.initState();

    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),

        boxShadow: _focus.hasFocus
            ? [
                BoxShadow(
                  // color: theme.primaryColor.withOpacity(isDark ? 0.18 : 0.08),
                  color: AppColors.gold.withOpacity(isDark ? 0.16 : 0.07),
                  blurRadius: isDark ? 18 : 12,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),

      child: TextFormField(
        controller: widget.controller,

        focusNode: _focus,

        validator: widget.validator,

        onTap: widget.onTap,

        onChanged: widget.onChanged,

        keyboardType: widget.keyboardType,

        readOnly: widget.readOnly,

        maxLines: widget.isPassword ? 1 : widget.maxLines,

        obscureText: widget.isPassword ? _obscure : false,

        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),

        decoration: InputDecoration(
          labelText: widget.label,

          prefixIcon: Icon(
            widget.icon,
            color: _focus.hasFocus
                ? theme.primaryColor
                : theme.iconTheme.color?.withOpacity(0.5),
          ),

          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: theme.primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : widget.suffix,
        ),
      ),
    );
  }
}
