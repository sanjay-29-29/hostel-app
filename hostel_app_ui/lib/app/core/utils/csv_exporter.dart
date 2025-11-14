// // excel_exporter.dart
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:excel/excel.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:open_file/open_file.dart';

// /// Minimal typed model used by your app (same as before)
// class WasteModelCSV {
//   final DateTime date;
//   final String session;
//   final double coffeWaste; // liters
//   final double studentWaste; // kg
//   final double foodCookedWaste; // kg
//   final int presentCount;
//   final int absentCount;

//   WasteModelCSV({
//     required this.date,
//     required this.session,
//     required this.coffeWaste,
//     required this.studentWaste,
//     required this.foodCookedWaste,
//     required this.presentCount,
//     required this.absentCount,
//   });
// }

// class ExcelExporter {
//   static Future<File> exportXlsx({
//     required String collegeName,
//     required String hostelName,
//     required DateTime from,
//     required DateTime to,
//     required List<WasteModelCSV> wastes,
//     String filenamePrefix = 'waste_report',
//   }) async {
//     // Create workbook
//     final excel = Excel.createExcel(); // creates default 'Sheet1'
//     final sheetName = 'Report';

//     // Ensure the desired sheet exists (rename default if needed)
//     if (excel.sheets.containsKey('Sheet1') && !excel.sheets.containsKey(sheetName)) {
//       excel.rename('Sheet1', sheetName);
//     } else if (!excel.sheets.containsKey(sheetName)) {
//       excel.appendSheet(sheetName);
//     }

//     final Sheet sheet = excel[sheetName]!;

//     // We'll insert rows at increasing row index
//     var rowIndex = 0;

//     // Helper closure to insert a row and increment index
//     void writeRow(Iterable<dynamic> values) {
//       sheet.insertRowIterables(values, rowIndex);
//       rowIndex++;
//     }

//     // Header rows (mimic merged visual by placing text in same row/cols)
//     writeRow(['', '', collegeName]); // row 0
//     writeRow(['', '', hostelName]); // row 1
//     writeRow(['', '', 'From: ${_format(from)}   To: ${_format(to)}']); // row 2
//     writeRow(List.filled(7, '')); // row 3 - blank-ish

//     // Column headers (row 4)
//     writeRow([
//       'Date',
//       'Session',
//       'Milk & Coffee (L)',
//       'Student Waste (Kg)',
//       'Cooked Waste (Kg)',
//       'Present',
//       'Absent',
//     ]);

//     // Data rows starting from row 5...
//     for (final w in wastes) {
//       writeRow([
//         _format(w.date),
//         w.session,
//         _formatNumValue(w.coffeWaste),
//         _formatNumValue(w.studentWaste),
//         _formatNumValue(w.foodCookedWaste),
//         w.presentCount,
//         w.absentCount,
//       ]);
//     }

//     // Encode workbook to bytes
//     final List<int>? bytes = excel.encode();
//     if (bytes == null) {
//       throw Exception('Failed to encode XLSX');
//     }
//     final Uint8List data = Uint8List.fromList(bytes);

//     // Pick directory (app-specific external or temp)
//     Directory? baseDir;
//     try {
//       baseDir = await getExternalStorageDirectory();
//     } catch (_) {
//       baseDir = null;
//     }
//     baseDir ??= await getTemporaryDirectory();

//     final fileName = '$filenamePrefix${DateTime.now().millisecondsSinceEpoch}.xlsx';
//     final file = File('${baseDir.path}/$fileName');

//     if (!(await file.parent.exists())) {
//       await file.parent.create(recursive: true);
//     }

//     await file.writeAsBytes(data, flush: true);

//     debugPrint('XLSX written to: ${file.path}');

//     return file;
//   }

//   /// Open (view) the XLSX file using platform handler
//   static Future<OpenResult> viewFile(File file) async {
//     if (kIsWeb) {
//       throw UnsupportedError('Viewing files via OpenFile is not supported on web. Use web download flow.');
//     }
//     return OpenFile.open(file.path);
//   }

//   /// Share the file using share_plus
//   static Future<void> shareFile(File file, {String? text}) async {
//     if (kIsWeb) {
//       throw UnsupportedError('Share is not implemented for web in this helper.');
//     }
//     final xfile = XFile(file.path);
//     await Share.shareXFiles([xfile], text: text ?? 'Hostel waste XLSX');
//   }

//   /// Copy to Downloads folder (best-effort). On Android 11+ consider MediaStore/SAF for robust behavior.
//   static Future<File> downloadToDownloads(File sourceFile) async {
//     if (kIsWeb) {
//       throw UnsupportedError('Download to device filesystem is not supported on web by this helper.');
//     }

//     try {
//       final extDirs = await getExternalStorageDirectories(type: StorageDirectory.downloads);
//       if (extDirs != null && extDirs.isNotEmpty) {
//         final downloadsDir = extDirs.first;
//         final dest = File('${downloadsDir.path}/${sourceFile.uri.pathSegments.last}');
//         if (!(await dest.parent.exists())) {
//           await dest.parent.create(recursive: true);
//         }
//         final copied = await sourceFile.copy(dest.path);
//         debugPrint('Copied to Downloads: ${copied.path}');
//         return copied;
//       } else {
//         final tmp = await getTemporaryDirectory();
//         final dest = File('${tmp.path}/${sourceFile.uri.pathSegments.last}');
//         final copied = await sourceFile.copy(dest.path);
//         debugPrint('Downloads dir not found — copied to temp: ${copied.path}');
//         return copied;
//       }
//     } catch (e) {
//       debugPrint('Failed to copy to Downloads: $e');
//       rethrow;
//     }
//   }

//   // --------------------
//   // Helpers
//   // --------------------
//   static String _format(DateTime d) =>
//       '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

//   // Return int if whole number, else double — keeps numeric cells numeric in Excel.
//   static dynamic _formatNumValue(num? n) {
//     if (n == null) return '';
//     if (n % 1 == 0) return n.toInt();
//     return n.toDouble();
//   }
// }
