import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/features/shared/models/timing/timing_model.dart';
import 'package:hostel_app/features/waste/repository/waste_manage_repository.dart';

class WasteManageState {
  final bool isLoading;

  const WasteManageState({this.isLoading = false});

  WasteManageState copyWith({bool? isLoading}) {
    return WasteManageState(isLoading: isLoading ?? this.isLoading);
  }

  factory WasteManageState.inital() => WasteManageState(isLoading: false);
}

class WasteManageNotifier extends Notifier<WasteManageState> {
  late final WasteManageRepository _repository;

  WasteManageState build() {
    _repository = ref.read(wasteManagementRepositoryProvider);
    return WasteManageState.inital();
  }

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

  Future<void> fetchWaste(DateTime date, TimingModel timing) async {
    state = state.copyWith(isLoading: true);
    final response = await _repository.fetchWaste(date, timing);
    response.fold(onSuccess: (waste) {}, onFailure: (error) {});
  }
}
