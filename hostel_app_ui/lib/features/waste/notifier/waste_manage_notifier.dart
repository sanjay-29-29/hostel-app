import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/features/shared/models/timing/timing_model.dart';
import 'package:hostel_app/features/shared/models/waste/waste_model.dart';
import 'package:hostel_app/features/waste/model/waste_create.dart';
import 'package:hostel_app/features/waste/repository/waste_manage_repository.dart';

class WasteManageState {
  final bool isFetching;
  final bool isCreating;
  final WasteModel? waste;

  const WasteManageState({
    this.isFetching = false,
    this.waste = null,
    this.isCreating = false,
  });

  WasteManageState copyWith({
    bool? isFetching,
    bool? isCreating,
    WasteModel? waste,
  }) {
    return WasteManageState(
      isCreating: isCreating ?? this.isCreating,
      isFetching: isFetching ?? this.isFetching,
      waste: waste ?? this.waste,
    );
  }

  WasteManageState clearWaste() {
    return WasteManageState(
      isFetching: this.isFetching,
      waste: null,
    );
  }

  factory WasteManageState.inital() => WasteManageState(isFetching: false);
}

class WasteManageNotifier extends Notifier<WasteManageState> {
  late final WasteRepository _repository;

  WasteManageState build() {
    _repository = ref.read(wasteManagementRepositoryProvider);
    return WasteManageState.inital();
  }

  Future<void> addWaste(WasteCreateModel waste) async {
    state = state.copyWith(isCreating: true);
    final response = await _repository.addWaste(waste);
    response.fold(
      onSuccess: (res) {
        state = state.copyWith(isCreating: false);
        ToastHelper.showSuccess('Waste Data Added Successfully');
      },
      onFailure: (e) {
        state = state.copyWith(isCreating: false);
        ToastHelper.showError('Failed to add Waste Data');
      },
    );
  }

  Future<void> updateWaste(int id, WasteCreateModel waste) async {
    final response = await _repository.updateWaste(state.waste!.id, waste);
    response.fold(
      onSuccess: (res) {
        state = state.copyWith(isCreating: false);
        ToastHelper.showSuccess('Waste Updated Successfully');
      },
      onFailure: (e) {
        state = state.copyWith(isCreating: false);
        ToastHelper.showError('Failed to Update Waste Data');
      },
    );
  }

  Future<void> fetchWaste(DateTime date, TimingModel timing) async {
    state = state.copyWith(isFetching: true);
    final response = await _repository.fetchSingleWaste(date, timing);
    response.fold(
      onSuccess: (waste) {
        state = state.copyWith(waste: waste, isFetching: false);
      },
      onFailure: (error) {
        state = state.clearWaste().copyWith(isFetching: false);
      },
    );
    print(state.isFetching);
  }
}
