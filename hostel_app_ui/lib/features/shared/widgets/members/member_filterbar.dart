import 'package:flutter/material.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';

class MemberFilterBar extends StatelessWidget {
  final String selectedStatus;
  final String sortOrder;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onSortChanged;

  const MemberFilterBar({
    super.key,
    required this.selectedStatus,
    required this.sortOrder,
    required this.onStatusChanged,
    required this.onSortChanged,
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
              DropdownButton<String>(
                value: selectedStatus,
                items: const [
                  DropdownMenuItem(
                    value: 'All',
                    child: ResponsiveText(
                      'All',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'New',
                    child: ResponsiveText(
                      'New',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Active',
                    child: ResponsiveText(
                      'Active',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Inactive',
                    child: ResponsiveText(
                      'Inactive',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) onStatusChanged(value);
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
              DropdownButton<String>(
                value: sortOrder,
                items: const [
                  DropdownMenuItem(
                    value: 'A-Z',
                    child: ResponsiveText(
                      'A - Z',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Z-A',
                    child: ResponsiveText(
                      'Z - A',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) onSortChanged(value);
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
