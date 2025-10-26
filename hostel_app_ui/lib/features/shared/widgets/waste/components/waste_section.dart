import 'package:flutter/material.dart';
import 'package:hostel_app/features/waste/notifier/waste_manage_notifier.dart';
import 'package:hostel_app/features/shared/widgets/waste/waste_input_field.dart';

class WasteSection extends StatelessWidget {
  final MealTypesEnum selectedMeal;
  final TextEditingController coffeeWasteController;
  final TextEditingController studentWasteController;
  final TextEditingController cookedWasteController;
  final TextEditingController milkWasteController;

  const WasteSection({
    super.key,
    required this.selectedMeal,
    required this.coffeeWasteController,
    required this.studentWasteController,
    required this.cookedWasteController,
    required this.milkWasteController,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> fields = [];

    if (selectedMeal == MealTypesEnum.Breakfast) {
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
    } else if (selectedMeal == MealTypesEnum.Snacks) {
      fields.add(_buildCoffeeMilkField());
    } else if (selectedMeal == MealTypesEnum.Lunch ||
        selectedMeal == MealTypesEnum.Dinner) {
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

    return  Column(children: fields);
  }

  Widget _buildCoffeeMilkField() {
    return WasteInputField(
      label: 'Coffee & Milk Waste',
      controller: coffeeWasteController,
      showLiters: true,
    );
  }
}
