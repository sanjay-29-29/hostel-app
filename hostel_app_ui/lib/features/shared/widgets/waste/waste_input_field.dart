import 'package:flutter/material.dart';
import 'package:hostel_app/app/wrapper_class/responsive_container.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';

class WasteInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool showLiters;
  final double conversionFactor;

  const WasteInputField({
    super.key,
    required this.label,
    required this.controller,
    this.showLiters = false,
    this.conversionFactor = 0.97,
  });

  double _getLiters() {
    final kg = double.tryParse(controller.text) ?? 0;
    return kg * conversionFactor;
  }

  @override
  Widget build(BuildContext context) {
    final liters = _getLiters();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ResponsiveText(label, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              ResponsiveContainer(
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: TextField(
                  controller: controller,
                  onChanged: (_) {
                    (context as Element).markNeedsBuild();
                  },
                  decoration: InputDecoration(
                    suffixText: 'kg',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              if (showLiters) ...[
                const SizedBox(width: 8),
                ResponsiveText(
                  '${liters.toStringAsFixed(2)} L',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
