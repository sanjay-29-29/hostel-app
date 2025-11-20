// excel_exporter.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hostel_app/features/shared/models/waste/waste_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';


class ExcelExporter {
  static Future<File> exportXlsx({
    required String collegeName,
    required String hostelName,
    required DateTime from,
    required DateTime to,
    required List<WasteModel> reports,
    String filenamePrefix = 'waste_report',
  }) async {
    final excel = Excel.createExcel(); 
    final sheetName = 'Report_${hostelName}';

    if (excel.sheets.containsKey('Sheet1') && !excel.sheets.containsKey(sheetName)) {
      try {
        excel.rename('Sheet1', sheetName);
      } catch (_) {
        excel[sheetName];
      }
    } else if (!excel.sheets.containsKey(sheetName)) {
      excel[sheetName];
    }

    final Sheet sheet = excel[sheetName];

    var rowIndex = 0;

    CellValue? _toCellValue(dynamic v) {
      if (v == null || (v is String && v.isEmpty)) {
        return TextCellValue(''); 
      }

      if (v is int) {
        return IntCellValue(v);
      }

      if (v is double) {
        return DoubleCellValue(v);
      }

      if (v is num) {
        final n = v.toDouble();
        if (n % 1 == 0) return IntCellValue(n.toInt());
        return DoubleCellValue(n);
      }
      if (v is DateTime) {
        return TextCellValue(_format(v));
      }
      return TextCellValue(v.toString());
    }
    void writeRow(List<dynamic> values) {
      final List<CellValue?> row = values.map<CellValue?>((v) => _toCellValue(v)).toList();
      sheet.insertRowIterables(row, rowIndex);
      rowIndex++;
    }

    writeRow(['', '', collegeName]); 
    writeRow(['', '', hostelName]); 
    writeRow(['', '', 'From: ${_format(from)}   To: ${_format(to)}']); 
    writeRow(List.filled(7, '')); 

    writeRow([
      'Date',
      'Session',
      'Milk & Coffee (L)',
      'Student Waste (Kg)',
      'Cooked Waste (Kg)',
      'Present',
      'Absent',
    ]);

    for (final r in reports) {
      if (r.attendances.isEmpty) {
        writeRow([
          _format(r.date),
          r.timingName,
          _formatNumNullable(r.coffeWaste),
          _formatNumValue(r.studentWaste),
          _formatNumValue(r.foodCookedWaste),
          0,
          0,
        ]);
      } else {
        for (final a in r.attendances) {
          writeRow([
            _format(r.date),
            r.timingName,
            _formatNumNullable(r.coffeWaste),
            _formatNumValue(r.studentWaste),
            _formatNumValue(r.foodCookedWaste),
            a.studentsPresent,
            a.studentsAbsent,
          ]);
        }
      }
    }
    final List<int>? bytes = excel.encode();
    if (bytes == null) {
      throw Exception('Failed to encode XLSX');
    }
    final Uint8List data = Uint8List.fromList(bytes);

    Directory? baseDir;
    try {
      baseDir = await getExternalStorageDirectory();
    } catch (_) {
      baseDir = null;
    }
    baseDir ??= await getTemporaryDirectory();

    final fileName = '$filenamePrefix${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final file = File('${baseDir.path}/$fileName');

    if (!(await file.parent.exists())) {
      await file.parent.create(recursive: true);
    }

    await file.writeAsBytes(data, flush: true);

    debugPrint('XLSX written to: ${file.path}');

    return file;
  }

  static Future<OpenResult> viewFile(File file) async {
    if (kIsWeb) {
      throw UnsupportedError('Viewing files via OpenFile is not supported on web.');
    }
    return OpenFile.open(file.path);
  }

  static Future<void> shareFile(File file, {String? text}) async {
    if (kIsWeb) {
      throw UnsupportedError('Share is not implemented for web in this helper.');
    }
    final xfile = XFile(file.path);
    await Share.shareXFiles([xfile], text: text ?? 'Hostel waste XLSX');
  }

  static Future<File> downloadToDownloads(File sourceFile) async {
    if (kIsWeb) {
      throw UnsupportedError('Download to device filesystem is not supported on web by this helper.');
    }

    try {
      final extDirs = await getExternalStorageDirectories(type: StorageDirectory.downloads);
      if (extDirs != null && extDirs.isNotEmpty) {
        final downloadsDir = extDirs.first;
        final dest = File('${downloadsDir.path}/${sourceFile.uri.pathSegments.last}');
        if (!(await dest.parent.exists())) {
          await dest.parent.create(recursive: true);
        }
        final copied = await sourceFile.copy(dest.path);
        debugPrint('Copied to Downloads: ${copied.path}');
        return copied;
      } else {
        final tmp = await getTemporaryDirectory();
        final dest = File('${tmp.path}/${sourceFile.uri.pathSegments.last}');
        final copied = await sourceFile.copy(dest.path);
        debugPrint('Downloads dir not found — copied to temp: ${copied.path}');
        return copied;
      }
    } catch (e) {
      debugPrint('Failed to copy to Downloads: $e');
      rethrow;
    }
  }

  static String _format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  static dynamic _formatNumValue(num? n) {
    if (n == null) return '';
    if (n is int) return n;
    if (n % 1 == 0) return n.toInt();
    return n.toDouble();
  }

  static dynamic _formatNumNullable(num? n) {
    if (n == null) return '';
    return _formatNumValue(n);
  }
}
