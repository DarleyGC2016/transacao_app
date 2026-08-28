import 'package:flutter/material.dart'
    show TextFormField, InputDecoration, OutlineInputBorder, Icons;
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

      decoration: InputDecoration(
        labelText: label,
        hintText: 'R\$ 0,00',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.monetization_on),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
