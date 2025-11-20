import 'package:flutter/material.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/shared/widgets/waste/custom_calendra.dart';
import 'package:intl/intl.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';

class DateSection extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const DateSection({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ResponsiveText(
          DateFormat('MMMM, dd, yyyy').format(selectedDate),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    );
  }
}
