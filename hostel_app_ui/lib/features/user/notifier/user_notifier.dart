import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
import 'package:hostel_app/app/provider/dio_provider.dart';
import 'package:hostel_app/features/shared/models/user/user_model.dart';
import 'package:hostel_app/features/user/repository/user_repository.dart';

enum SelectedStatus {
  All('All'),
  Inactive('Inactive'),
  Active('Active');

  final String value;
  const SelectedStatus(this.value);
}

enum SortOrder {
  Ascending('A-Z'),
  Descending('Z-A');

  final String value;
  const SortOrder(this.value);
}

class ManageUserState {
  List<UserModel> users;
  List<UserModel> filteredUsers;
  SelectedStatus selectedStatus;

  ManageUserState({
    required this.users,
    required this.filteredUsers,
    required this.selectedStatus,
  });

  ManageUserState copyWith({
    List<UserModel>? users,
    List<UserModel>? filteredUsers,
    SelectedStatus? selectedStatus,
  }) {
    return ManageUserState(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  factory ManageUserState.initial() => ManageUserState(
    users: [],
    filteredUsers: [],
    selectedStatus: SelectedStatus.Active,
  );
}

class ManageUserNotifier extends StateNotifier<ManageUserState> {
  final UserRepository _repository;

  ManageUserNotifier(this._repository) : super(ManageUserState.initial());

  Future<void> fetchUsers() async {
    final response = await _repository.fetchUsers();
    response.fold(
      onSuccess: (users) {
        state = state.copyWith(users: users, filteredUsers: users);
      },
      onFailure: (e) {
        ToastHelper.showError('Something went wrong');
      },
    );
  }

  void searchUsers(String? searchQuery) {
    if (searchQuery == null) return;
    List<UserModel> filteredResult = state.users.where((member) {
      final matchesSearch =
          member.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          member.role.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesSearch;
    }).toList();
    state = state.copyWith(filteredUsers: filteredResult);
  }

  void sort(SortOrder? sortOrder) {
    // TODO 
  }

  void filterStatus(SelectedStatus? selectedStatus) {
    // TODO
  }

  void clearSearch() {
    state = state.copyWith(filteredUsers: state.users);
  }
}

final UserRepositoryProvider = Provider(
  (ref) => UserRepositoryImpl(ref.watch(dioClientProvider)),
);

final manageUserNotifierProvider =
    StateNotifierProvider<ManageUserNotifier, ManageUserState>((ref) {
      return ManageUserNotifier(ref.watch(UserRepositoryProvider));
    });
