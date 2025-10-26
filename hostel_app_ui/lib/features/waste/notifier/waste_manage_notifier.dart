import 'package:flutter_riverpod/legacy.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/features/waste/repository/waste_manage_repository.dart';

enum MealTypesEnum {
  Breakfast('Breakfast'),
  Lunch('Lunch'),
  Snacks('Snacks'),
  Dinner('Dinner');

  final String value;
  const MealTypesEnum(this.value);
}

class WasteManageState {
  final MealTypesEnum meals;
  final bool isLoading;

  const WasteManageState({
    this.meals = MealTypesEnum.Breakfast,
    this.isLoading = false,
  });

  WasteManageState copyWith({MealTypesEnum? meals, bool? isLoading}) {
    return WasteManageState(
      meals: meals ?? this.meals,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory WasteManageState.inital() => WasteManageState(isLoading: false);
}

class WasteManageNotifier extends StateNotifier<WasteManageState> {
  final WasteManageRepository _repository;
  WasteManageNotifier(this._repository) : super(WasteManageState.inital());

  Future<void> addWasteData() async {
    state = state.copyWith(isLoading: true);
    final response = await _repository.addWasteData();
    response.fold(
      onSuccess: (res) {
        state = state.copyWith(isLoading: false);
        ToastHelper.showSuccess(res);
      },
      onFailure: (e) {
        state = state.copyWith(isLoading: false);
        ToastHelper.showError('Failed to add waste data');
      },
    );
  }
}
