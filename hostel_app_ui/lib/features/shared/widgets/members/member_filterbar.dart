import 'package:flutter/material.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';

class MemberFilterBar<R extends Enum, L extends Enum> extends StatelessWidget {
  final List<R> leftDropdown;
  final R leftSelectedValue;
  final ValueChanged<R?> leftChanged;
  final List<L> rightDropdownValue;
  final L rightSelectedValue;
  final ValueChanged<L?> rightChanged;

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
              DropdownButton<R>(
                value: leftSelectedValue,
                items: leftDropdown
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
                onChanged: (value) {
                  // if (value != null) onStatusChanged();
                },
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
              DropdownButton<L>(
                value: rightSelectedValue,
                items: rightDropdownValue
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
                onChanged: (value) {
                  // if (value != null) onSortChanged(value);
                },
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
