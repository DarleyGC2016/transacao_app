import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show InputDecoration, TextFormField;

class InputTempo extends StatelessWidget {
  var onTap;

  final TextEditingController timeController;

  late final Widget? icone;

  final String label;

  final String hintText;

  FormFieldValidator<String> validator;

  InputTempo({
    super.key,
    required this.label,
    required this.onTap,
    required this.timeController,
    this.icone,
    required this.hintText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: timeController,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: icone,
        hintText: hintText,
      ),
      onTap: onTap,
      validator: validator,
    );
  }
}
