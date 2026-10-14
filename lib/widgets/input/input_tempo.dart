import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show InputDecoration, TextFormField, Theme, OutlineInputBorder, Colors;

class InputTempo extends StatelessWidget {
  final VoidCallback onTap;

  final TextEditingController timeController;

  final Widget? icone;
  final Color colorIcon;

  final String label;

  final String hintText;

  final FormFieldValidator<String> validator;

  final ValueChanged<String>? onChanged;

  const InputTempo({
    super.key,
    required this.label,
    required this.onTap,
    required this.timeController,
    this.icone,
    required this.colorIcon,
    required this.hintText,
    required this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // readOnly: true,
      controller: timeController,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icone,
        prefixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return Colors.red;
          }

          if (states.contains(WidgetState.focused)) {
            return Colors.yellowAccent;
          }

          return colorIcon;
        }),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.8,
          ),
        ),
        hintText: hintText,
      ),
      onTap: onTap,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
