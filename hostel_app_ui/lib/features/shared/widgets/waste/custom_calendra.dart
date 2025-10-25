import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/shared/widgets/waste/custom_month.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendarDialog extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const CustomCalendarDialog({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<CustomCalendarDialog> createState() => _CustomCalendarDialogState();
}

class _CustomCalendarDialogState extends State<CustomCalendarDialog> {
  late DateTime _displayMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _displayMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  List<DateTime> _getCalendarDays() {
    final firstDayOfMonth = DateTime(
      _displayMonth.year,
      _displayMonth.month,
      1,
    );
    final daysToSubtract = firstDayOfMonth.weekday - 1;
    final firstDayOfCalendar = firstDayOfMonth.subtract(
      Duration(days: daysToSubtract),
    );

    return List.generate(
      42,
      (index) => firstDayOfCalendar.add(Duration(days: index)),
    );
  }

  void _previousMonth() {
    setState(() {
      _displayMonth = DateUtils.addMonthsToMonthDate(_displayMonth, -1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayMonth = DateUtils.addMonthsToMonthDate(_displayMonth, 1);
    });
  }

  Future<void> _selectMonthYear(BuildContext context) async {
    final picked = await showCustomMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
    );
    if (picked != null && picked != _displayMonth) {
      setState(() {
        _displayMonth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 15),
            _buildWeekdays(),
            const SizedBox(height: 10),
            _buildCalendarGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _previousMonth,
        ),
        GestureDetector(
          onTap: () => _selectMonthYear(context),
          child: Row(
            children: [
              ResponsiveText(
                "${DateFormat('MMMM').format(_displayMonth)} ${_displayMonth.year}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _nextMonth,
        ),
      ],
    );
  }

  Widget _buildWeekdays() {
    final weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 7,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (_, index) {
        return Center(
          child: Text(
            weekdays[index],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarGrid() {
    final calendarDays = _getCalendarDays();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: calendarDays.length, // 42 days
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemBuilder: (_, index) {
        final date = calendarDays[index];
        final isSelected = DateUtils.isSameDay(date, _selectedDate);
        final isCurrentMonth = date.month == _displayMonth.month;

        Color boxColor;
        Color textColor;

        if (isSelected) {
          boxColor = ColorConstants.primaryColor;
          textColor = Colors.white;
        } else if (isCurrentMonth) {
          boxColor = Colors.grey.shade200;
          textColor = Colors.black87;
        } else {
          boxColor = Colors.transparent;
          textColor = Colors.grey.shade400;
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
            widget.onDateSelected(date);
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              "${date.day}",
              style: TextStyle(
                color: textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
