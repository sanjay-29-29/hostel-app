import 'package:flutter/material.dart';
import 'package:hostel_app/app/wrapper_class/responsive_container.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: ResponsiveContainer(child: Text('Add Member Screen')),
          ),
        ],
      ),
    );
  }
}
