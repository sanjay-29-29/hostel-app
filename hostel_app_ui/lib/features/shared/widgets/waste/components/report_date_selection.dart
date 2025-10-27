import 'package:flutter/material.dart';
import 'package:hostel_app/app/wrapper_class/responsive_container.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/shared/widgets/waste/custom_calendra.dart';
import 'package:intl/intl.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';

class ReportDateSection extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final String label;

  const ReportDateSection({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ResponsiveContainer(
          width: 173,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ResponsiveText(
                label,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              GestureDetector(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => CustomCalendarDialog(
                      selectedDate: selectedDate,
                      onDateSelected: onDateChanged,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.calendar_month, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        ResponsiveText(
          DateFormat('MMMM, dd, yyyy').format(selectedDate),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
