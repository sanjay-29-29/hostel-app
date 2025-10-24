import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> items;
  final String? value;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
      decoration: InputDecoration(
        label: ResponsiveText(
          label,
          style:  TextStyle(
            color: ColorConstants.darkRed,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        hintText: hint,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          height: 1.2,
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(color: Colors.black)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
