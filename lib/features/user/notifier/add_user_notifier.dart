import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/app/router/router.dart';
import 'package:hostel_app/features/shared/models/error/backend_error_model.dart';
import 'package:hostel_app/features/shared/models/user/user_model.dart';
import 'package:hostel_app/features/user/model/create_user_model.dart';
import 'package:hostel_app/features/user/repository/user_repository.dart';

class AddUserState {
  BackendError? error;
  bool isLoading;

  AddUserState({this.error, this.isLoading = false});

  AddUserState copyWith({BackendError? error, bool? isLoading}) {
    return AddUserState(error: error, isLoading: isLoading ?? this.isLoading);
  }

  factory AddUserState.initial() => AddUserState();
}

class AddUserNotifier extends Notifier<AddUserState> {
  late final UserRepository repository;

  AddUserState build() {
    repository = ref.read(userRepositoryProvider);
    return AddUserState.initial();
  }

  Future<void> createUser(CreateUserModel model) async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await repository.createUser(model);
    response.fold(
      onSuccess: (response) {
        ToastHelper.showSuccess('User created successfully');
        state = state.copyWith(error: null, isLoading: false);
        router.pop();
      },
      onFailure: (e) {
        state = state.copyWith(error: e, isLoading: false);
      },
    );
  }

  Future<void> UpdateUser(UpdateUserModel model) async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await repository.updateUser(model);
    response.fold(
      onSuccess: (response) {
        ToastHelper.showSuccess('User updated successfully');
        state = state.copyWith(error: null, isLoading: false);
        router.pop();
      },
      onFailure: (e) {
        state = state.copyWith(error: e, isLoading: false);
      },
    );
  }
}
