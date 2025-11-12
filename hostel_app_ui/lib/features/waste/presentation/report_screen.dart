import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
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

  HostelModel? _selectedHostel;

  void handleFetchData() async {
    if (_selectedHostel == null) return;
    await ref.read(wasteManageNotifierProvider.notifier).fetchWasteWithRange(
          hostel: _selectedHostel,
          start: fromDate,
          end: toDate,
        );
  }

  @override
  Widget build(BuildContext context) {
    final baseInfo = ref.watch(authNotifierProvider).baseInfo;
    final wastes = ref.watch(wasteManageNotifierProvider).wastes;

    final spotsStudentWaste = <FlSpot>[];
    final spotsFoodWaste = <FlSpot>[];
    final spotsCoffeeWaste = <FlSpot>[];

    if (wastes != null)
      for (int i = 0; i < wastes.length; i++) {
        final d = wastes[i];
        if (d.studentWaste != null) {
          spotsStudentWaste
              .add(FlSpot(i.toDouble(), d.studentWaste!.toDouble()));
        }
        if (d.foodCookedWaste != null) {
          spotsFoodWaste
              .add(FlSpot(i.toDouble(), d.foodCookedWaste!.toDouble()));
        }
        if (d.coffeWaste != null) {
          spotsCoffeeWaste.add(FlSpot(i.toDouble(), d.coffeWaste!.toDouble()));
        }
      }

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
                  DropdownMenu<HostelModel>(
                    onSelected: (hostel) {
                      setState(() {
                        _selectedHostel = hostel;
                      });
                      handleFetchData();
                    },
                    dropdownMenuEntries: baseInfo!.hostels
                        .map(
                          (val) => DropdownMenuEntry<HostelModel>(
                            value: val,
                            label: val.name,
                          ),
                        )
                        .toList(),
                  ),
                  if (wastes != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        height: 500,
                        child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index < 0 || index >= wastes.length)
                                      return const SizedBox.shrink();
                                    final date = wastes[index].date;
                                    return Text(
                                      "${date.day}/${date.month}",
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                            ),
                            gridData: const FlGridData(show: true),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              // Student Waste Line
                              LineChartBarData(
                                spots: spotsStudentWaste,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                              ),
                              // Food Cooked Waste Line
                              LineChartBarData(
                                spots: spotsFoodWaste,
                                isCurved: true,
                                color: Colors.green,
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                              ),
                              // Coffee Waste Line
                              LineChartBarData(
                                spots: spotsCoffeeWaste,
                                isCurved: true,
                                color: Colors.brown,
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
