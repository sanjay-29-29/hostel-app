import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/core/utils/xlxs_exporter.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
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

  // Chart grouping options
  String _selectedGrouping = 'Daily';
  final List<String> _groupingOptions = [
    'Daily',
    'Weekly',
    'Monthly',
    'By Timing',
  ];

  // Scrolling controllers
  final ScrollController _lineChartScrollController = ScrollController();
  final ScrollController _barChartScrollController = ScrollController();

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

  Future<void> _exportCsv() async {
    if (_selectedHostel == null) {
      ToastHelper.showInfo('Select hostel & dates first');
      return;
    }

    setState(() => _loading = true);
    try {
      final f = await ExcelExporter.exportXlsx(
        collegeName: 'KEC',
        hostelName: _selectedHostel!.name,
        from: fromDate,
        to: toDate,
        reports: ref.read(wasteManageNotifierProvider).wastes ?? [],
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
      await ExcelExporter.viewFile(_lastFile!);
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
      await ExcelExporter.shareFile(_lastFile!, text: 'Hostel waste report');
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
      final dest = await ExcelExporter.downloadToDownloads(_lastFile!);
      ToastHelper.showSuccess('Saved to: ${dest.path}');
    } catch (e) {
      ToastHelper.showError('Download failed: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildSummaryCards(List wastes) {
    final totalStudentWaste = wastes
        .where((w) => w.studentWaste != null)
        .fold(0.0, (sum, w) => sum + w.studentWaste!.toDouble());
    final totalFoodWaste = wastes
        .where((w) => w.foodCookedWaste != null)
        .fold(0.0, (sum, w) => sum + w.foodCookedWaste!.toDouble());
    final totalCoffeeWaste = wastes
        .where((w) => w.coffeWaste != null)
        .fold(0.0, (sum, w) => sum + w.coffeWaste!.toDouble());
    final totalWaste = totalStudentWaste + totalFoodWaste + totalCoffeeWaste;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Waste',
            '${totalWaste.toStringAsFixed(1)} kg',
            Icons.delete_outline,
            Colors.red.shade100,
            Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Student Waste',
            '${totalStudentWaste.toStringAsFixed(1)} kg',
            Icons.person_outline,
            Colors.blue.shade100,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Food Waste',
            '${totalFoodWaste.toStringAsFixed(1)} kg',
            Icons.restaurant_outlined,
            Colors.green.shade100,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Coffee Waste',
            '${totalCoffeeWaste.toStringAsFixed(1)} kg',
            Icons.local_cafe_outlined,
            Colors.brown.shade100,
            Colors.brown,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color backgroundColor,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 24),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: iconColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection(List wastes) {
    // Group data based on selected grouping
    final groupedData = _groupWasteData(wastes);

    // Generate chart data from grouped data
    final spotsStudentWaste = <FlSpot>[];
    final spotsFoodWaste = <FlSpot>[];
    final spotsCoffeeWaste = <FlSpot>[];

    for (int i = 0; i < groupedData.length; i++) {
      final data = groupedData[i];
      spotsStudentWaste.add(FlSpot(i.toDouble(), data['studentWaste']));
      spotsFoodWaste.add(FlSpot(i.toDouble(), data['foodCookedWaste']));
      spotsCoffeeWaste.add(FlSpot(i.toDouble(), data['coffeWaste']));
    }

    return Column(
      children: [
        // Line Chart
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Waste Trends Over Time',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          // Grouping Dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedGrouping,
                              underline: const SizedBox.shrink(),
                              items: _groupingOptions.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedGrouping = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.trending_up, color: Colors.grey.shade600),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getChartSubtitle(),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  // Legend
                  _buildLegend(),
                  const SizedBox(height: 24),

                  SizedBox(
                    height: 400,
                    child: Scrollbar(
                      controller: _lineChartScrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _lineChartScrollController,
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: groupedData.length > 10
                              ? groupedData.length * 60.0
                              : MediaQuery.of(context).size.width - 100,
                          child: LineChart(
                            LineChartData(
                              backgroundColor: Colors.white,
                              titlesData: FlTitlesData(
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      if (index < 0 ||
                                          index >= groupedData.length) {
                                        return const SizedBox.shrink();
                                      }
                                      final label = groupedData[index]['label'];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          label,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 50,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toInt()}kg',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                drawHorizontalLine: true,
                                horizontalInterval: 5,
                                verticalInterval: 1,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: Colors.grey.shade200,
                                  strokeWidth: 1,
                                ),
                                getDrawingVerticalLine: (value) => FlLine(
                                  color: Colors.grey.shade200,
                                  strokeWidth: 1,
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              minX: 0,
                              maxX: (groupedData.length - 1).toDouble(),
                              lineBarsData: [
                                // Student Waste Line
                                LineChartBarData(
                                  spots: spotsStudentWaste,
                                  isCurved: true,
                                  color: Colors.blue,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                              radius: 4,
                                              color: Colors.blue,
                                              strokeWidth: 2,
                                              strokeColor: Colors.white,
                                            ),
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.blue.withOpacity(0.1),
                                  ),
                                ),
                                // Food Cooked Waste Line
                                LineChartBarData(
                                  spots: spotsFoodWaste,
                                  isCurved: true,
                                  color: Colors.green,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                              radius: 4,
                                              color: Colors.green,
                                              strokeWidth: 2,
                                              strokeColor: Colors.white,
                                            ),
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.green.withOpacity(0.1),
                                  ),
                                ),
                                // Coffee Waste Line
                                LineChartBarData(
                                  spots: spotsCoffeeWaste,
                                  isCurved: true,
                                  color: Colors.brown.shade600,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                              radius: 4,
                                              color: Colors.brown.shade600,
                                              strokeWidth: 2,
                                              strokeColor: Colors.white,
                                            ),
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.brown.shade600.withOpacity(
                                      0.1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Pie Chart
        _buildPieChart(wastes),

        const SizedBox(height: 24),

        // Bar Chart
        _buildBarChart(wastes),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Student Waste', Colors.blue),
        const SizedBox(width: 24),
        _buildLegendItem('Food Waste', Colors.green),
        const SizedBox(width: 24),
        _buildLegendItem('Coffee Waste', Colors.brown.shade600),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildPieChart(List wastes) {
    final totalStudentWaste = wastes
        .where((w) => w.studentWaste != null)
        .fold(0.0, (sum, w) => sum + w.studentWaste!.toDouble());
    final totalFoodWaste = wastes
        .where((w) => w.foodCookedWaste != null)
        .fold(0.0, (sum, w) => sum + w.foodCookedWaste!.toDouble());
    final totalCoffeeWaste = wastes
        .where((w) => w.coffeWaste != null)
        .fold(0.0, (sum, w) => sum + w.coffeWaste!.toDouble());

    final total = totalStudentWaste + totalFoodWaste + totalCoffeeWaste;

    if (total == 0) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Waste Distribution',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.pie_chart, color: Colors.grey.shade600),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Total waste breakdown by category',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 300,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 60,
                        sections: [
                          PieChartSectionData(
                            color: Colors.blue,
                            value: totalStudentWaste,
                            title:
                                '${((totalStudentWaste / total) * 100).toStringAsFixed(1)}%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.green,
                            value: totalFoodWaste,
                            title:
                                '${((totalFoodWaste / total) * 100).toStringAsFixed(1)}%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.brown.shade600,
                            value: totalCoffeeWaste,
                            title:
                                '${((totalCoffeeWaste / total) * 100).toStringAsFixed(1)}%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPieChartLegendItem(
                          'Student Waste',
                          '${totalStudentWaste.toStringAsFixed(1)} kg',
                          Colors.blue,
                        ),
                        const SizedBox(height: 16),
                        _buildPieChartLegendItem(
                          'Food Waste',
                          '${totalFoodWaste.toStringAsFixed(1)} kg',
                          Colors.green,
                        ),
                        const SizedBox(height: 16),
                        _buildPieChartLegendItem(
                          'Coffee Waste',
                          '${totalCoffeeWaste.toStringAsFixed(1)} kg',
                          Colors.brown.shade600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartLegendItem(String title, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(List wastes) {
    // Group data based on selected grouping for bar chart too
    final groupedData = _groupWasteData(wastes);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Waste Comparison',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.bar_chart, color: Colors.grey.shade600),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${_selectedGrouping} waste comparison by category',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 24),

              _buildLegend(),
              const SizedBox(height: 24),

              SizedBox(
                height: 300,
                child: Scrollbar(
                  controller: _barChartScrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _barChartScrollController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: groupedData.length > 8
                          ? groupedData.length * 80.0
                          : MediaQuery.of(context).size.width - 100,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: groupedData.isEmpty
                              ? 10
                              : groupedData
                                        .map(
                                          (data) => [
                                            data['studentWaste'] as double,
                                            data['foodCookedWaste'] as double,
                                            data['coffeWaste'] as double,
                                          ].reduce((a, b) => a > b ? a : b),
                                        )
                                        .reduce((a, b) => a > b ? a : b) *
                                    1.2,
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                      final index = value.toInt();
                                      if (index >= 0 &&
                                          index < groupedData.length) {
                                        final label =
                                            groupedData[index]['label'];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: Text(
                                            label,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                reservedSize: 40,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          barGroups: groupedData.asMap().entries.map((entry) {
                            final index = entry.key;
                            final data = entry.value;
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: data['studentWaste'],
                                  color: Colors.blue,
                                  width: 12,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                ),
                                BarChartRodData(
                                  toY: data['foodCookedWaste'],
                                  color: Colors.green,
                                  width: 12,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                ),
                                BarChartRodData(
                                  toY: data['coffeWaste'],
                                  color: Colors.brown.shade600,
                                  width: 12,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                ),
                              ],
                              barsSpace: 2,
                            );
                          }).toList(),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            drawVerticalLine: false,
                            horizontalInterval: 5,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: Colors.grey.shade200,
                              strokeWidth: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get chart subtitle based on grouping
  String _getChartSubtitle() {
    switch (_selectedGrouping) {
      case 'Weekly':
        return 'Weekly waste generation patterns';
      case 'Monthly':
        return 'Monthly waste generation patterns';
      case 'By Timing':
        return 'Waste generation by meal timing';
      case 'Daily':
      default:
        return 'Daily waste generation patterns';
    }
  }

  // Data grouping helper methods
  List<Map<String, dynamic>> _groupWasteData(List wastes) {
    if (wastes.isEmpty) return [];

    switch (_selectedGrouping) {
      case 'Weekly':
        return _groupByWeek(wastes);
      case 'Monthly':
        return _groupByMonth(wastes);
      case 'By Timing':
        return _groupByTiming(wastes);
      case 'Daily':
      default:
        // For daily, limit to last 15 entries for better visibility
        final limitedWastes = wastes.length > 15
            ? wastes.sublist(wastes.length - 15)
            : wastes;
        return limitedWastes
            .map(
              (waste) => {
                'date': waste.date,
                'studentWaste': (waste.studentWaste ?? 0).toDouble(),
                'foodCookedWaste': (waste.foodCookedWaste ?? 0).toDouble(),
                'coffeWaste': (waste.coffeWaste ?? 0).toDouble(),
                'label': '${waste.date.day}/${waste.date.month}',
              },
            )
            .toList();
    }
  }

  List<Map<String, dynamic>> _groupByWeek(List wastes) {
    Map<String, Map<String, double>> weeklyData = {};

    for (var waste in wastes) {
      final date = waste.date as DateTime;
      final weekStart = date.subtract(Duration(days: date.weekday - 1));
      final weekKey = '${weekStart.day}/${weekStart.month}';

      if (!weeklyData.containsKey(weekKey)) {
        weeklyData[weekKey] = {
          'studentWaste': 0.0,
          'foodCookedWaste': 0.0,
          'coffeWaste': 0.0,
        };
      }

      weeklyData[weekKey]!['studentWaste'] =
          (weeklyData[weekKey]!['studentWaste']! +
          (waste.studentWaste ?? 0).toDouble());
      weeklyData[weekKey]!['foodCookedWaste'] =
          (weeklyData[weekKey]!['foodCookedWaste']! +
          (waste.foodCookedWaste ?? 0).toDouble());
      weeklyData[weekKey]!['coffeWaste'] =
          (weeklyData[weekKey]!['coffeWaste']! +
          (waste.coffeWaste ?? 0).toDouble());
    }

    return weeklyData.entries
        .map(
          (entry) => {
            'date': entry.key,
            'studentWaste': entry.value['studentWaste']!,
            'foodCookedWaste': entry.value['foodCookedWaste']!,
            'coffeWaste': entry.value['coffeWaste']!,
            'label': 'Week ${entry.key}',
          },
        )
        .toList();
  }

  List<Map<String, dynamic>> _groupByMonth(List wastes) {
    Map<String, Map<String, double>> monthlyData = {};

    for (var waste in wastes) {
      final date = waste.date as DateTime;
      final monthKey = '${date.month}/${date.year}';

      if (!monthlyData.containsKey(monthKey)) {
        monthlyData[monthKey] = {
          'studentWaste': 0.0,
          'foodCookedWaste': 0.0,
          'coffeWaste': 0.0,
        };
      }

      monthlyData[monthKey]!['studentWaste'] =
          (monthlyData[monthKey]!['studentWaste']! +
          (waste.studentWaste ?? 0).toDouble());
      monthlyData[monthKey]!['foodCookedWaste'] =
          (monthlyData[monthKey]!['foodCookedWaste']! +
          (waste.foodCookedWaste ?? 0).toDouble());
      monthlyData[monthKey]!['coffeWaste'] =
          (monthlyData[monthKey]!['coffeWaste']! +
          (waste.coffeWaste ?? 0).toDouble());
    }

    return monthlyData.entries
        .map(
          (entry) => {
            'date': entry.key,
            'studentWaste': entry.value['studentWaste']!,
            'foodCookedWaste': entry.value['foodCookedWaste']!,
            'coffeWaste': entry.value['coffeWaste']!,
            'label': entry.key,
          },
        )
        .toList();
  }

  List<Map<String, dynamic>> _groupByTiming(List wastes) {
    Map<String, Map<String, double>> timingData = {};

    for (var waste in wastes) {
      final timingName = waste.timingName;

      if (!timingData.containsKey(timingName)) {
        timingData[timingName] = {
          'studentWaste': 0.0,
          'foodCookedWaste': 0.0,
          'coffeWaste': 0.0,
        };
      }

      timingData[timingName]!['studentWaste'] =
          (timingData[timingName]!['studentWaste']! +
          (waste.studentWaste ?? 0).toDouble());
      timingData[timingName]!['foodCookedWaste'] =
          (timingData[timingName]!['foodCookedWaste']! +
          (waste.foodCookedWaste ?? 0).toDouble());
      timingData[timingName]!['coffeWaste'] =
          (timingData[timingName]!['coffeWaste']! +
          (waste.coffeWaste ?? 0).toDouble());
    }

    return timingData.entries
        .map(
          (entry) => {
            'date': entry.key,
            'studentWaste': entry.value['studentWaste']!,
            'foodCookedWaste': entry.value['foodCookedWaste']!,
            'coffeWaste': entry.value['coffeWaste']!,
            'label': entry.key,
          },
        )
        .toList();
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
              padding: const EdgeInsets.all(12),
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
                  DropdownMenu<KitchenModel>(
                    onSelected: (kitchen) {
                      setState(() {
                        _selectedHostel = kitchen;
                      });
                      handleFetchData();
                    },
                    dropdownMenuEntries: user!.kitchens
                        .map(
                          (val) => DropdownMenuEntry<KitchenModel>(
                            value: val,
                            label: val.name,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  if (wastes != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _loading ? null : _exportCsv,
                          icon: _loading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.download),
                          label: const Text('Export CSV'),
                        ),
                        const SizedBox(width: 12),

                        if (_lastFile != null) ...[
                          IconButton(
                            onPressed: (_lastFile != null && !_loading)
                                ? _viewCsv
                                : null,
                            icon: const Icon(Icons.visibility),
                            tooltip: 'View exported CSV',
                          ),

                          IconButton(
                            onPressed: (_lastFile != null && !_loading)
                                ? _shareCsv
                                : null,
                            icon: const Icon(Icons.share),
                            tooltip: 'Share exported CSV',
                          ),

                          IconButton(
                            onPressed: (_lastFile != null && !_loading)
                                ? _downloadCsv
                                : null,
                            icon: const Icon(Icons.file_download),
                            tooltip: 'Save to Downloads',
                          ),
                        ],
                      ],
                    ),

                  const SizedBox(height: 24),

                  if (wastes != null) ...[_buildChartsSection(wastes)],
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
