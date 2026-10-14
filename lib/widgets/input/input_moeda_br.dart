import 'package:flutter/material.dart'
    show
        TextFormField,
        InputDecoration,
        OutlineInputBorder,
        Icons,
        Theme,
        Colors;
import 'package:flutter/services.dart' show TextInputFormatter;
import 'package:flutter/widgets.dart';

class InputMoedaBr extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final double moeda;
  final List<TextInputFormatter> textInputFormatter;
  final String label;
  final FormFieldValidator<String>? validator;

  const InputMoedaBr({
    super.key,
    required this.label,
    required this.onChanged,
    required this.moeda,
    required this.textInputFormatter,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: textInputFormatter,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'R\$ 0,00',
        prefixIcon: const Icon(Icons.monetization_on),
        prefixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return Colors.red;
          }
          return Colors.green;
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
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
