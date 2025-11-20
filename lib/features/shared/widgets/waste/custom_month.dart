import 'package:flutter/material.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:intl/intl.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';

Future<DateTime?> showCustomMonthYearPicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  DateTime selectedDate = initialDate;
  bool showYearSelector = false;

  return showDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left),
                        onPressed: () {
                          setState(() {
                            if (showYearSelector) {
                              selectedDate = DateTime(
                                selectedDate.year - 12,
                                selectedDate.month,
                              );
                            } else {
                              selectedDate = DateTime(
                                selectedDate.year - 1,
                                selectedDate.month,
                              );
                            }
                          });
                        },
                      ),

                      InkWell(
                        onTap: () => setState(
                          () => showYearSelector = !showYearSelector,
                        ),
                        child: ResponsiveText(
                          '${selectedDate.year}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.primaryColor,
                          ),
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.arrow_right),
                        onPressed: () {
                          setState(() {
                            if (showYearSelector) {
                              selectedDate = DateTime(
                                selectedDate.year + 12,
                                selectedDate.month,
                              );
                            } else {
                              selectedDate = DateTime(
                                selectedDate.year + 1,
                                selectedDate.month,
                              );
                            }
                          });
                        },
                      ),
                    ],
                  ),

                  const ResponsiveSizedBox(height: 8),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: showYearSelector
                        ? _YearGridView(
                            key: const ValueKey('yearGrid'),
                            selectedDate: selectedDate,
                            onSelect: (year) {
                              setState(() {
                                selectedDate = DateTime(
                                  year,
                                  selectedDate.month,
                                );
                                showYearSelector = false;
                              });
                            },
                          )
                        : _MonthGridView(
                            key: const ValueKey('monthGrid'),
                            selectedDate: selectedDate,
                            onSelect: (month) {
                              final picked = DateTime(selectedDate.year, month);
                              Navigator.pop(context, picked);
                            },
                          ),
                  ),

                  const ResponsiveSizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

class _MonthGridView extends StatelessWidget {
  final DateTime selectedDate;
  final Function(int) onSelect;

  const _MonthGridView({
    super.key,
    required this.selectedDate,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 12,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, index) {
        final month = DateTime(0, index + 1);
        final isSelected = selectedDate.month == (index + 1);

        return GestureDetector(
          onTap: () => onSelect(index + 1),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorConstants.primaryColor
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              DateFormat.MMM().format(month),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _YearGridView extends StatelessWidget {
  final DateTime selectedDate;
  final Function(int) onSelect;

  const _YearGridView({
    super.key,
    required this.selectedDate,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final startYear = (selectedDate.year ~/ 12) * 12; 
    final years = List.generate(12, (i) => startYear + i);

    return GridView.builder(
      shrinkWrap: true,
      itemCount: years.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, index) {
        final year = years[index];
        final isSelected = selectedDate.year == year;

        return GestureDetector(
          onTap: () => onSelect(year),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorConstants.primaryColor
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              '$year',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}
