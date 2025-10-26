import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/features/shared/models/error/backend_error_model.dart';
import 'package:hostel_app/features/shared/models/hostel/hostel_model.dart';
import 'package:hostel_app/features/shared/models/role/role_model.dart';
import 'package:hostel_app/features/user/model/create_user_model.dart';
import 'package:hostel_app/features/user/repository/user_repository.dart';

class AddUserState {
  List<RoleModel> roles;
  List<HostelModel> hostels;
  BackendError? error;

  AddUserState({required this.roles, required this.hostels, this.error});

  AddUserState copyWith({
    List<RoleModel>? roles,
    List<HostelModel>? hostels,
    BackendError? error,
  }) {
    return AddUserState(
      roles: roles ?? this.roles,
      hostels: hostels ?? this.hostels,
      error: error,
    );
  }

  factory AddUserState.initial() => AddUserState(roles: [], hostels: []);
}

class AddUserNotifier extends Notifier<AddUserState> {
  late final UserRepository repository;

  AddUserState build() {
    repository = ref.read(userRepositoryProvider);
    return AddUserState.initial();
  }

  Future<void> fetchCreateInfo() async {
    final response = await repository.fetchUserCreateInfo();
    response.fold(
      onSuccess: (response) {
        state =
            state.copyWith(roles: response.roles, hostels: response.hostels);
      },
      onFailure: (e) {},
    );
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

final addUserNotifierProvider =
    NotifierProvider<AddUserNotifier, AddUserState>(AddUserNotifier.new);
