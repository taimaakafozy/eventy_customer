import 'package:flutter/material.dart';

class PrimaryDropdownField extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  /// اختياري لعرض نص مختلف عن القيمة
  final String Function(String value)? displayMapper;

  const PrimaryDropdownField({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    required this.value,
    required this.onChanged,
    this.displayMapper,
  });

  @override
  State<PrimaryDropdownField> createState() =>
      _PrimaryDropdownFieldState();
}

class _PrimaryDropdownFieldState
    extends State<PrimaryDropdownField> {
  final FocusNode _focus = FocusNode();

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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: _focus.hasFocus
            ? [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.45),
                  blurRadius: 10,
                )
              ]
            : [],
      ),
      child: DropdownButtonFormField<String>(
        focusNode: _focus,
        value: widget.value,
        isExpanded: true,
        borderRadius: BorderRadius.circular(16),
        dropdownColor: theme.cardColor,
        menuMaxHeight: 300,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: theme.primaryColor,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon:
              Icon(widget.icon, color: theme.primaryColor),
          border: theme.inputDecorationTheme.border,
          floatingLabelStyle:
              theme.inputDecorationTheme.labelStyle,
        ),
        items: widget.items.map((e) {
          final text =
              widget.displayMapper != null
                  ? widget.displayMapper!(e)
                  : e;

          return DropdownMenuItem<String>(
            value: e,
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        onChanged: widget.onChanged,
      ),
    );
  }
}