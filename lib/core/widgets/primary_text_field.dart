// import 'package:flutter/material.dart';

// class PrimaryTextField extends StatefulWidget {
//   final String label;
//   final IconData icon;
//   final TextEditingController controller;
//   final bool isPassword;
//   final TextInputType keyboardType;
//   final VoidCallback? onTap;
//   final ValueChanged<String>? onChanged;
//   final bool readOnly; // ✅ أضفنا هذه الخاصية

//   const PrimaryTextField({
//     super.key,
//     required this.label,
//     required this.icon,
//     required this.controller,
//     this.isPassword = false,
//     this.keyboardType = TextInputType.text,
//     this.onTap,
//     this.onChanged,
//     this.readOnly = false,
//   });

//   @override
//   State<PrimaryTextField> createState() => _PrimaryTextFieldState();
// }

// class _PrimaryTextFieldState extends State<PrimaryTextField> {
//   final FocusNode _focus = FocusNode();
//   bool _obscure = true;

//   @override
//   void initState() {
//     super.initState();
//     _focus.addListener(() => setState(() {}));
//   }

//   @override
//   void dispose() {
//     _focus.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       padding: const EdgeInsets.all(2),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14),
//        boxShadow: _focus.hasFocus
//     ? [
//         BoxShadow(
//           color: theme.primaryColor.withOpacity(
//             theme.brightness == Brightness.light
//                 ? 0.12
//                 : 0.35,
//           ),
//           blurRadius: theme.brightness == Brightness.light ? 6 : 10,
//           spreadRadius: 0,
//           offset: const Offset(0, 2),
//         ),
//       ]
//     : [],
//       ),
//       child: TextFormField(
//         readOnly: widget.readOnly,

//         onChanged: widget.onChanged,
//         controller: widget.controller,
//         focusNode: _focus,
//         onTap: widget.onTap,
//         obscureText: widget.isPassword ? _obscure : false,
//         keyboardType: widget.keyboardType,
//         decoration: InputDecoration(
//           labelText: widget.label,
//           labelStyle: theme.inputDecorationTheme.labelStyle,
//           floatingLabelStyle: theme.inputDecorationTheme.labelStyle,
//           prefixIcon: Icon(widget.icon, color: theme.primaryColor),
//           suffixIcon: widget.isPassword
//               ? IconButton(
//                   icon: Icon(
//                     _obscure ? Icons.visibility_off : Icons.visibility,
//                     color: theme.primaryColor,
//                   ),
//                   onPressed: () => setState(() => _obscure = !_obscure),
//                 )
//               : null,
//           border: theme.inputDecorationTheme.border,
//         ),
//       ),
//     );
//   }
// }

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
  State<PrimaryTextField> createState() =>
      _PrimaryTextFieldState();
}

class _PrimaryTextFieldState
    extends State<PrimaryTextField> {

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

    return AnimatedContainer(

      duration: const Duration(milliseconds: 200),

      padding: const EdgeInsets.all(2),

      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(14),

        boxShadow: _focus.hasFocus
            ? [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(
                    theme.brightness == Brightness.light
                        ? 0.12
                        : 0.35,
                  ),
                  blurRadius:
                      theme.brightness == Brightness.light
                          ? 6
                          : 10,
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

        maxLines:
            widget.isPassword ? 1 : widget.maxLines,

        obscureText:
            widget.isPassword ? _obscure : false,

        decoration: InputDecoration(

          labelText: widget.label,

          prefixIcon: Icon(
            widget.icon,
            color: theme.primaryColor,
          ),

          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_off
                        : Icons.visibility,
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