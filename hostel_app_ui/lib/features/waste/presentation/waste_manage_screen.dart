import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/features/shared/widgets/forms/custom_dropdown_field.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:hostel_app/features/shared/widgets/primary_button.dart';
import 'package:hostel_app/features/shared/widgets/waste/components/date_section.dart';
import 'package:hostel_app/features/shared/widgets/waste/components/student_count_selection.dart';
import 'package:hostel_app/features/shared/widgets/waste/components/waste_section.dart';
import 'package:hostel_app/features/shared/widgets/waste/date_selector.dart';
import 'package:hostel_app/features/waste/notifier/waste_manage_notifier.dart';

class WasteManageScreen extends ConsumerStatefulWidget {
  const WasteManageScreen({super.key});

  @override
  ConsumerState<WasteManageScreen> createState() => _WasteManageScreenState();
}

class _WasteManageScreenState extends ConsumerState<WasteManageScreen> {
  DateTime selectedDate = DateTime.now();
  MealTypesEnum selectedMeal = MealTypesEnum.Breakfast;

  final coffeeWasteController = TextEditingController();
  final studentWasteController = TextEditingController();
  final cookedWasteController = TextEditingController();
  final milkWasteController = TextEditingController();

  double coffeeInLiters = 0;

  @override
  void dispose() {
    coffeeWasteController.dispose();
    studentWasteController.dispose();
    cookedWasteController.dispose();
    milkWasteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(title1: 'FOOD', title2: 'MANAGEMENT'),
            const ResponsiveSizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                spacing: 16,
                children: [
                  DateSection(
                    selectedDate: selectedDate,
                    onDateChanged: (DateTime value) {
                      setState(() {
                        selectedDate = value;
                      });
                    },
                  ),
                  DateSelector(
                    selectedDate: selectedDate,
                    onSelect: (d) => setState(() => selectedDate = d),
                  ),
                  CustomDropdownField<MealTypesEnum>(
                    label: 'Select Meal Time',
                    hint: 'Choose a meal time',
                    items: MealTypesEnum.values,
                    value: selectedMeal,
                    getLabel: (meal) => meal.value,
                    onChanged: (val) {
                      setState(() {
                        selectedMeal = val!;
                        _clearFields();
                      });
                    },
                  ),

                  // StudentCountSection(
                  // hostelTotals: {
                  // 'Ilango': 120,
                  // },
                  // ),
                  StudentCountSection(
                    hostelTotals: {'Ilango': 120, 'Kamban': 90},
                  ),

                  WasteSection(
                    coffeeWasteController: coffeeWasteController,
                    selectedMeal: selectedMeal,
                    studentWasteController: studentWasteController,
                    cookedWasteController: cookedWasteController,
                    milkWasteController: milkWasteController,
                  ),
                  PrimaryButton(text: 'Save', onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearFields() {
    coffeeWasteController.clear();
    studentWasteController.clear();
    cookedWasteController.clear();
    milkWasteController.clear();
    setState(() => coffeeInLiters = 0);
  }
}
