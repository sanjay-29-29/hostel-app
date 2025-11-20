import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';

class DateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onSelect;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onSelect,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  void didUpdateWidget(DateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedDate();
      });
    }
  }

  void _scrollToSelectedDate() {
    final days = _generateDays();
    final selectedIndex = days.indexWhere(
      (date) =>
          date.day == widget.selectedDate.day &&
          date.month == widget.selectedDate.month &&
          date.year == widget.selectedDate.year,
    );

    if (selectedIndex != -1) {
      final itemWidth = 70.0; // width + margin
      final viewportWidth = MediaQuery.of(context).size.width;
      final offset =
          (selectedIndex * itemWidth) - (viewportWidth / 2) + (itemWidth / 2);

      _scrollController.animateTo(
        offset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List<DateTime> _generateDays() {
    return List.generate(
      100,
      (i) => DateTime.now().add(Duration(days: i - 50)), // Center around today
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _generateDays();

    return SizedBox(
      height: 100,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        itemCount: days.length,
        itemBuilder: (_, index) {
          final date = days[index];
          final isSelected =
              date.day == widget.selectedDate.day &&
              date.month == widget.selectedDate.month &&
              date.year == widget.selectedDate.year;

          return GestureDetector(
            onTap: () => widget.onSelect(date),
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
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
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
