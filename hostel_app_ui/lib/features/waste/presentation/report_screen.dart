import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/utils/csv_exporter.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:hostel_app/features/shared/models/waste/waste_model.dart';
import 'package:hostel_app/features/shared/models/kitchen/kitchen_model.dart';
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

  KitchenModel? _selectedHostel;

  File? _lastFile;
  bool _loading = false;

  void handleFetchData() async {
    if (_selectedHostel == null) return;
    await ref
        .read(wasteManageNotifierProvider.notifier)
        .fetchWasteWithRange(
          hostel: _selectedHostel,
          start: fromDate,
          end: toDate,
        );
  }

  final mockWastes = [
    WasteModelCSV(
      date: DateTime(2025, 01, 10),
      session: 'Breakfast',
      coffeWaste: 1.2, // Liters
      studentWaste: 2.5, // Kg
      foodCookedWaste: 5.0, // Kg
      presentCount: 45,
      absentCount: 5,
    ),
    WasteModelCSV(
      date: DateTime(2025, 01, 10),
      session: 'Lunch',
      coffeWaste: 0.0,
      studentWaste: 3.1,
      foodCookedWaste: 6.0,
      presentCount: 48,
      absentCount: 2,
    ),
    WasteModelCSV(
      date: DateTime(2025, 01, 10),
      session: 'Snacks',
      coffeWaste: 0.5,
      studentWaste: 1.6,
      foodCookedWaste: 2.5,
      presentCount: 42,
      absentCount: 8,
    ),
    WasteModelCSV(
      date: DateTime(2025, 01, 10),
      session: 'Dinner',
      coffeWaste: 0.0,
      studentWaste: 2.7,
      foodCookedWaste: 5.2,
      presentCount: 44,
      absentCount: 6,
    ),
  ];

  Future<void> _exportCsv() async {
    if (_selectedHostel == null) {
      ToastHelper.showInfo('Select hostel & dates first');
      return;
    }

    setState(() => _loading = true);
    try {
      final f = await CsvExporter.exportWasteData(
        collegeName: 'KEC',
        hostelName: _selectedHostel!.name,
        from: fromDate,
        to: toDate,
        wastes: mockWastes,
      );
      setState(() => _lastFile = f);
      ToastHelper.showSuccess('Exported CSV: ${f.path}');
    } catch (e) {
      ToastHelper.showError('Export failed: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _viewCsv() async {
    if (_lastFile == null) {
      ToastHelper.showInfo('No exported file yet. Export first.');
      return;
    }
    setState(() => _loading = true);
    try {
      await CsvExporter.viewFile(_lastFile!);
    } catch (e) {
      ToastHelper.showError('Open failed: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _shareCsv() async {
    if (_lastFile == null) {
      ToastHelper.showInfo('No exported file yet. Export first.');
      return;
    }
    setState(() => _loading = true);
    try {
      await CsvExporter.shareFile(_lastFile!, text: 'Hostel waste report');
    } catch (e) {
      ToastHelper.showError('Share failed: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _downloadCsv() async {
    if (_lastFile == null) {
      ToastHelper.showInfo('No exported file yet. Export first.');
      return;
    }
    setState(() => _loading = true);
    try {
      final dest = await CsvExporter.downloadToDownloads(_lastFile!);
      ToastHelper.showSuccess('Saved to: ${dest.path}');
    } catch (e) {
      ToastHelper.showError('Download failed: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).user;
    final wastes = ref.watch(wasteManageNotifierProvider).wastes;
    final spotsStudentWaste = <FlSpot>[];
    final spotsFoodWaste = <FlSpot>[];
    final spotsCoffeeWaste = <FlSpot>[];

    if (wastes != null)
      for (int i = 0; i < wastes.length; i++) {
        final d = wastes[i];
        if (d.studentWaste != null) {
          spotsStudentWaste.add(
            FlSpot(i.toDouble(), d.studentWaste!.toDouble()),
          );
        }
        if (d.foodCookedWaste != null) {
          spotsFoodWaste.add(
            FlSpot(i.toDouble(), d.foodCookedWaste!.toDouble()),
          );
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
                  const SizedBox(height: 12),
                  DropdownMenu<HostelModel>(
                    onSelected: (hostel) {
                      setState(() {
                        _selectedHostel = hostel;
                      });
                      handleFetchData();
                    },
                    dropdownMenuEntries: user!.hostels
                        .map(
                          (val) => DropdownMenuEntry<HostelModel>(
                            value: val,
                            label: val.name,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),

                  // Export + action buttons row
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _loading ? null : _exportCsv,
                        icon: _loading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.download),
                        label: const Text('Export CSV'),
                      ),
                      const SizedBox(width: 12),

                      // View button
                      IconButton(
                        onPressed: (_lastFile != null && !_loading) ? _viewCsv : null,
                        icon: const Icon(Icons.visibility),
                        tooltip: 'View exported CSV',
                      ),

                      // Share button
                      IconButton(
                        onPressed: (_lastFile != null && !_loading) ? _shareCsv : null,
                        icon: const Icon(Icons.share),
                        tooltip: 'Share exported CSV',
                      ),

                      // Download button
                      IconButton(
                        onPressed: (_lastFile != null && !_loading) ? _downloadCsv : null,
                        icon: const Icon(Icons.file_download),
                        tooltip: 'Save to Downloads',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

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
                                      '${date.day}/${date.month}',
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
                    ),
                  if (_lastFile != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Last exported: ${_lastFile!.path}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}