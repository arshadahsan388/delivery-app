import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

// Mock Firebase auth state for testing
class MockFirebaseAuthState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  const MockFirebaseAuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  MockFirebaseAuthState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
  }) {
    return MockFirebaseAuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

// Mock Firebase auth provider for testing
final mockFirebaseAuthProvider = StateNotifierProvider<MockFirebaseAuthNotifier, MockFirebaseAuthState>((ref) {
  return MockFirebaseAuthNotifier();
});

class MockFirebaseAuthNotifier extends StateNotifier<MockFirebaseAuthState> {
  MockFirebaseAuthNotifier() : super(const MockFirebaseAuthState());

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      if (email.isNotEmpty && password.isNotEmpty) {
        final userModel = _createUserModel(email);
        state = state.copyWith(isLoading: false, user: userModel);
      } else {
        state = state.copyWith(
          isLoading: false, 
          error: 'Please enter email and password'
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        error: 'Login failed. Please try again.'
      );
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await Future.delayed(const Duration(seconds: 1));
      
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        final userModel = _createUserModel(email, customName: name);
        state = state.copyWith(isLoading: false, user: userModel);
      } else {
        state = state.copyWith(
          isLoading: false, 
          error: 'Please fill all fields'
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        error: 'Signup failed. Please try again.'
      );
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);
      
      // Simulate logout delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Clear user state
      state = const MockFirebaseAuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to sign out.');
    }
  }

  UserModel _createUserModel(String email, {String? customName}) {
    // Determine user role based on email pattern
    UserRole userRole;
    String userName;
    
    if (email.toLowerCase().contains('admin') || email.toLowerCase().contains('manager')) {
      userRole = UserRole.admin;
      userName = customName ?? 'Admin Manager';
    } else if (email.toLowerCase().contains('rider') || email.toLowerCase().contains('driver')) {
      userRole = UserRole.rider;
      userName = customName ?? 'Delivery Rider';
    } else {
      userRole = UserRole.customer;
      userName = customName ?? 'Customer User';
    }
    
    return UserModel(
      id: 'mock-${userRole.name}-${DateTime.now().millisecondsSinceEpoch}',
      name: userName,
      email: email,
      role: userRole,
      createdAt: DateTime.now(),
      isActive: true,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
