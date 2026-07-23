import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable numeric stepper: أزرار +/- مع إمكانية الكتابة المباشرة.
/// يُستخدم لعدد الضيوف وكذلك لكميات الخدمات الفرعية.
class PrimaryQuantityStepper extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int? max;
  final int step;
  final String? suffixLabel;

  const PrimaryQuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max,
    this.step = 1,
    this.suffixLabel,
  });

  @override
  State<PrimaryQuantityStepper> createState() => _PrimaryQuantityStepperState();
}

class _PrimaryQuantityStepperState extends State<PrimaryQuantityStepper> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(covariant PrimaryQuantityStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value.toString()) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _apply(int newValue) {
    var clamped = newValue;
    if (clamped < widget.min) clamped = widget.min;
    if (widget.max != null && clamped > widget.max!) clamped = widget.max!;

    widget.onChanged(clamped);

    if (_controller.text != clamped.toString()) {
      _controller.text = clamped.toString();
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor.withOpacity(.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoundBtn(icon: Icons.remove_rounded, onTap: () => _apply(widget.value - widget.step)),
          SizedBox(
            width: 60,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (v) {
                final parsed = int.tryParse(v);
                if (parsed != null) _apply(parsed);
              },
              onSubmitted: (v) => _apply(int.tryParse(v) ?? widget.min),
            ),
          ),
          _RoundBtn(icon: Icons.add_rounded, onTap: () => _apply(widget.value + widget.step)),
          if (widget.suffixLabel != null) ...[
            const SizedBox(width: 8),
            Text(widget.suffixLabel!, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.primaryColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}