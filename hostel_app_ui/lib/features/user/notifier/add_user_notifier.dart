import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/app_provider.dart';
import 'package:hostel_app/features/shared/models/error/backend_error_model.dart';
import 'package:hostel_app/features/user/model/create_user_model.dart';
import 'package:hostel_app/features/user/repository/user_repository.dart';

class AddUserState {
  BackendError? error;

  AddUserState({this.error});

  AddUserState copyWith({
    BackendError? error,
  }) {
    return AddUserState(
      error: error,
    );
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
    final response = await repository.createUser(model);
    response.fold(
      onSuccess: (response) {
        ToastHelper.showSuccess('User created succesfully');
        state = state.copyWith(error: null);
      },
      onFailure: (e) {
        state = state.copyWith(error: e);
      },
    );
  }
}
