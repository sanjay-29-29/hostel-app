import 'package:flutter/material.dart';
import 'package:hostel_app/features/shared/models/timing/timing_model.dart';
import 'package:hostel_app/features/shared/models/waste/waste_model.dart';
import 'package:hostel_app/features/shared/widgets/waste/waste_input_field.dart';

class WasteSection extends StatelessWidget {
  final TimingModel? selectedTiming;
  final TextEditingController coffeeWasteController;
  final TextEditingController studentWasteController;
  final TextEditingController cookedWasteController;
  final TextEditingController milkWasteController;

  const WasteSection({
    super.key,
    required this.coffeeWasteController,
    required this.studentWasteController,
    required this.cookedWasteController,
    required this.milkWasteController,
    this.selectedTiming,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> fields = [];

    if (selectedTiming?.id == 1) {
      fields.add(_buildCoffeeMilkField());
      fields.add(
        WasteInputField(
          label: 'Student Waste',
          controller: studentWasteController,
        ),
      );
      fields.add(
        WasteInputField(
          label: 'Food Cooked Waste',
          controller: cookedWasteController,
        ),
      );
    } else if (selectedTiming?.id == 4) {
      fields.add(_buildCoffeeMilkField());
    } else if (selectedTiming?.id == 2 || selectedTiming?.id == 3) {
      fields.add(
        WasteInputField(
          label: 'Student Waste',
          controller: studentWasteController,
        ),
      );
      fields.add(
        WasteInputField(
          label: 'Food Cooked Waste',
          controller: cookedWasteController,
        ),
      );
    }

    return Column(children: fields);
  }

  Widget _buildCoffeeMilkField() {
    return WasteInputField(
      label: 'Coffee & Milk Waste',
      controller: coffeeWasteController,
      showLiters: true,
    );
  }
}
