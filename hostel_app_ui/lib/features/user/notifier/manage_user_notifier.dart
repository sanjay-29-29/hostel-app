import 'package:flutter_riverpod/legacy.dart';
import 'package:hostel_app/app/core/utils/toast_utils.dart';
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
  final List<UserModel> users;
  final List<UserModel> filteredUsers;
  final SelectedStatus selectedStatus;
  final String? searchQuery;
  final SortOrder sortOrder;
  final bool isLoading;

  ManageUserState({
    required this.users,
    required this.filteredUsers,
    required this.selectedStatus,
    required this.sortOrder,
    this.searchQuery,
    this.isLoading = false,
  });

  ManageUserState copyWith({
    List<UserModel>? users,
    List<UserModel>? filteredUsers,
    SelectedStatus? selectedStatus,
    String? searchQuery,
    SortOrder? sortOrder,
    bool? isLoading,
  }) {
    return ManageUserState(
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOrder: sortOrder ?? this.sortOrder,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory ManageUserState.initial() => ManageUserState(
        users: [],
        filteredUsers: [],
        selectedStatus: SelectedStatus.All,
        sortOrder: SortOrder.Ascending,
        isLoading: false,
      );
}

class ManageUserNotifier extends StateNotifier<ManageUserState> {
  final UserRepository _repository;

  ManageUserNotifier(this._repository) : super(ManageUserState.initial());

  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true);

    final response = await _repository.fetchUsers();

    response.fold(
      onSuccess: (users) {
        state = state.copyWith(
          users: users,
          isLoading: false,
        );
        _applyAllFilters();
      },
      onFailure: (e) {
        state = state.copyWith(isLoading: false);
        ToastHelper.showError('Failed to fetch users');
      },
    );
  }

  void searchUsers(String? searchQuery) {
    state = state.copyWith(searchQuery: searchQuery);
    _applyAllFilters();
  }

  void sort(SortOrder? sortOrder) {
    state = state.copyWith(sortOrder: sortOrder);
    _applyAllFilters();
  }

  void filterByStatus(SelectedStatus? selectedStatus) {
    if (selectedStatus == null) return;
    state = state.copyWith(selectedStatus: selectedStatus);
    _applyAllFilters();
  }

  void clearSearch() {
    state = state.copyWith(
      searchQuery: null,
    );
    _applyAllFilters();
  }

  void clearAllFilters() {
    state = state.copyWith(
      searchQuery: null,
      selectedStatus: SelectedStatus.All,
      sortOrder: null,
    );
    _applyAllFilters();
  }

  void _applyAllFilters() {
    List<UserModel> filteredResult = state.users.where((user) {
      // Apply search filter
      final hasSearchQuery =
          state.searchQuery != null && state.searchQuery!.isNotEmpty;
      if (hasSearchQuery) {
        final matchesSearch = user.name
                .toLowerCase()
                .contains(state.searchQuery!.toLowerCase()) ||
            user.role.toLowerCase().contains(state.searchQuery!.toLowerCase());
        if (!matchesSearch) return false;
      }

      // Apply status filter
      switch (state.selectedStatus) {
        case SelectedStatus.Active:
          return user.isActive;
        case SelectedStatus.Inactive:
          return !user.isActive;
        case SelectedStatus.All:
          return true;
      }
    }).toList();

    // Apply sorting
    filteredResult = _applySorting(filteredResult);

    state = state.copyWith(filteredUsers: filteredResult);
  }

  List<UserModel> _applySorting(List<UserModel> users) {
    final sortedUsers = List<UserModel>.from(users);

    switch (state.sortOrder) {
      case SortOrder.Ascending:
        sortedUsers.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOrder.Descending:
        sortedUsers.sort((a, b) => b.name.compareTo(a.name));
        break;
    }

    return sortedUsers;
  }

  Future<void> addUser() async {
    // TODO
  }
}

