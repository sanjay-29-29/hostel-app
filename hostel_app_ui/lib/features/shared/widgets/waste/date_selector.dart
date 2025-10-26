import 'package:flutter/material.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:intl/intl.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';

class DateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onSelect;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final days = List.generate(
      5,
      (i) => selectedDate.add(Duration(days: i - 1)),
    );

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: days.length,
        itemBuilder: (_, index) {
          final date = days[index];
          final isSelected = date.day == selectedDate.day;

          return GestureDetector(
            onTap: () => onSelect(date),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: isSelected ? ColorConstants.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResponsiveText(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ResponsiveText(
                    DateFormat('EEE').format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
