import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:hostel_app/features/shared/widgets/waste/components/report_date_selection.dart';

class ReportViewScreen extends ConsumerStatefulWidget {
  const ReportViewScreen({super.key});

  @override
  ConsumerState<ReportViewScreen> createState() => _ReportViewScreenState();
}

class _ReportViewScreenState extends ConsumerState<ReportViewScreen> {
  DateTime fromDate = DateTime(
    DateTime.now().year,
    DateTime.now().month - 1,
    DateTime.now().day,
  );
  DateTime toDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(title1: 'REPORT', title2: 'VIEW'),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReportDateSection(
                        selectedDate: fromDate,
                        onDateChanged: (date) {
                          setState(() {
                            fromDate = date;
                            if (toDate.isBefore(fromDate)) {
                              toDate = fromDate;
                              ToastHelper.showInfo(
                                '"To" date adjusted to match "From" date.',
                              );
                            }
                          });
                        },
                        label: 'From',
                      ),
                      ReportDateSection(
                        selectedDate: toDate,
                        onDateChanged: (date) {
                          setState(() {
                            if (date.isBefore(fromDate)) {
                              ToastHelper.showInfo(
                                '“To” date cannot be before “From” date.',
                              );
                            } else {
                              toDate = date;
                            }
                          });
                        },
                        label: 'To',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
