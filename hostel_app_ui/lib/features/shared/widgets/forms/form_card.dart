import 'package:flutter/material.dart';
import 'package:hostel_app/app/wrapper_class/responsive_container.dart';

class FormCard extends StatelessWidget {
  final List<Widget> children;
  const FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      width: 366,
      padding: const [16, 16, 16, 16],
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
