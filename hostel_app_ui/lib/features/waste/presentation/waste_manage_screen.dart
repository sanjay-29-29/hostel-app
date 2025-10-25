import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/constants/color_constants.dart';
import 'package:hostel_app/app/wrapper_class/responsive_sizedbox.dart';
import 'package:hostel_app/app/wrapper_class/responsive_text.dart';
import 'package:hostel_app/features/shared/widgets/header_section.dart';
import 'package:hostel_app/features/shared/widgets/waste/custom_calendra.dart';
import 'package:hostel_app/features/shared/widgets/waste/date_selector.dart';
import 'package:hostel_app/features/shared/widgets/waste/student_count_card.dart';
import 'package:hostel_app/features/shared/widgets/waste/waste_input_field.dart';
import 'package:intl/intl.dart';

class WasteManageScreen extends ConsumerStatefulWidget {
  const WasteManageScreen({super.key});

  @override
  ConsumerState<WasteManageScreen> createState() => _WasteManageScreenState();
}

class _WasteManageScreenState extends ConsumerState<WasteManageScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedMeal = 'Breakfast';

  final coffeeWasteController = TextEditingController(text: '10');
  final studentWasteController = TextEditingController(text: '10');
  final cookedWasteController = TextEditingController(text: '15');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(title1: 'FOOD', title2: 'MANAGEMENT'),
            const ResponsiveSizedBox(height: 20),
            _buildDateAndCalendarButton(context),
            const ResponsiveSizedBox(height: 15),
            DateSelector(
              selectedDate: selectedDate,
              onSelect: (d) => setState(() => selectedDate = d),
            ),
            const ResponsiveSizedBox(height: 15),
            _buildMealDropdown(),
            _buildStudentSection(),
            const ResponsiveSizedBox(height: 20),
            _buildWasteSection(),
            const ResponsiveSizedBox(height: 30),
            _buildSaveButton(),
            const ResponsiveSizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDateAndCalendarButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ResponsiveText(
            DateFormat('MMMM, dd, yyyy').format(selectedDate),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (_) => CustomCalendarDialog(
                  selectedDate: selectedDate,
                  onDateSelected: (date) {
                    setState(() => selectedDate = date);
                  },
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: ColorConstants.primaryColor,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.calendar_month, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: DropdownButtonFormField<String>(
        value: selectedMeal,
        decoration: const InputDecoration(
          labelText: 'Select Meal Time',
          border: UnderlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 'Breakfast', child: Text('Breakfast')),
          DropdownMenuItem(value: 'Lunch', child: Text('Lunch')),
          DropdownMenuItem(value: 'Dinner', child: Text('Dinner')),
        ],
        onChanged: (val) => setState(() => selectedMeal = val!),
      ),
    );
  }

  Widget _buildStudentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: ColorConstants.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'No. Of Students',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const ResponsiveSizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                StudentCountCard(label: 'Ilango', count: '123'),
                StudentCountCard(label: 'Kamban', count: '123'),
                StudentCountCard(label: 'Total', count: '246'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWasteSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          WasteInputField(
            label: 'Coffee & Milk Waste',
            controller: coffeeWasteController,
          ),
          WasteInputField(
            label: 'Student Waste',
            controller: studentWasteController,
          ),
          WasteInputField(
            label: 'Food Cooked Waste',
            controller: cookedWasteController,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      onPressed: () {
        // save logic
      },
      child: const Text(
        'SAVE',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
