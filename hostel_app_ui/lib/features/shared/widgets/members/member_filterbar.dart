import 'package:flutter/material.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';

class MemberFilterBar<L extends Enum, R extends Enum> extends StatelessWidget {
  final List<L> leftDropdown;
  final L leftSelectedValue;
  final ValueChanged<L?> leftChanged;
  final List<R> rightDropdownValue;
  final R rightSelectedValue;
  final ValueChanged<R?> rightChanged;

  const MemberFilterBar({
    super.key,
    required this.leftDropdown,
    required this.leftSelectedValue,
    required this.leftChanged,
    required this.rightDropdownValue,
    required this.rightSelectedValue,
    required this.rightChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const ResponsiveText(
                'Status:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              DropdownButton<L>(
                value: leftSelectedValue,
                items: leftDropdown
                    .map(
                      (val) => DropdownMenuItem<L>(
                        value: val,
                        child: ResponsiveText(
                          val.name,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: leftChanged,
                borderRadius: BorderRadius.circular(12),
                dropdownColor: Colors.white,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                underline: const SizedBox(),
                icon: const Icon(Icons.filter_list, color: Colors.black54),
              ),
            ],
          ),
          Row(
            children: [
              const ResponsiveText(
                'Sort:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 8),
              DropdownButton<R>(
                value: rightSelectedValue,
                items: rightDropdownValue
                    .map(
                      (val) => DropdownMenuItem<R>(
                        value: val,
                        child: ResponsiveText(
                          val.name,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: rightChanged,
                borderRadius: BorderRadius.circular(12),
                dropdownColor: Colors.white,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                underline: const SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
