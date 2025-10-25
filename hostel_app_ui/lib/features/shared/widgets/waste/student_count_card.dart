import 'package:flutter/material.dart';

class StudentCountCard extends StatelessWidget {
  final String label;
  final String count;

  const StudentCountCard({super.key, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Text(count),
        ),
      ],
    );
  }
}
