import 'package:flutter/material.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final List<T> items;
  final String Function(T) getLabel;
  final T? value;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const CustomDropdownField({
    super.key,
    required this.getLabel,
    required this.label,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          label,
          style: TextStyle(
            color: ColorConstants.darkRed,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        DropdownButtonFormField<T>(
          initialValue: value,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          decoration: InputDecoration(
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
                  child: Text(
                    getLabel(e),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}
