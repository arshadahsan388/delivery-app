import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
// import '../services/auth_service.dart';

// Simple auth state for UI testing (without Firebase)
class SimpleAuthState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  const SimpleAuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  SimpleAuthState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
  }) {
    return SimpleAuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

// Simple auth provider (no Firebase dependency)
final simpleAuthProvider = StateNotifierProvider<SimpleAuthNotifier, SimpleAuthState>((ref) {
  return SimpleAuthNotifier();
});

class SimpleAuthNotifier extends StateNotifier<SimpleAuthState> {
  SimpleAuthNotifier() : super(const SimpleAuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    
    // Simulate login delay
    await Future.delayed(const Duration(seconds: 1));
    
    // For demo purposes, any email/password works
    if (email.isNotEmpty && password.isNotEmpty) {
      
      // Determine user role based on email pattern
      UserRole userRole;
      String userName;
      
      if (email.toLowerCase().contains('admin') || email.toLowerCase().contains('manager')) {
        userRole = UserRole.admin;
        userName = 'Admin Manager';
      } else if (email.toLowerCase().contains('rider') || email.toLowerCase().contains('driver')) {
        userRole = UserRole.rider;
        userName = 'Delivery Rider';
      } else {
        userRole = UserRole.customer;
        userName = 'Customer User';
      }
      
      final user = UserModel(
        id: 'demo-${userRole.name}-${DateTime.now().millisecondsSinceEpoch}',
        name: userName,
        email: email,
        role: userRole,
        createdAt: DateTime.now(),
        isActive: true,
      );
      
      state = state.copyWith(isLoading: false, user: user);
    } else {
      state = state.copyWith(
        isLoading: false, 
        error: 'Please enter email and password'
      );
    }
  }

  Future<void> signup(String name, String email, String password) async {
    state = state.copyWith(isLoading: true);
    
    await Future.delayed(const Duration(seconds: 1));
    
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      final user = UserModel(
        id: 'demo-user-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        role: UserRole.customer,
        createdAt: DateTime.now(),
        isActive: true,
      );
      
      state = state.copyWith(isLoading: false, user: user);
    } else {
      state = state.copyWith(
        isLoading: false, 
        error: 'Please fill all fields'
      );
    }
  }

  Future<void> logout() async {
    // Immediate logout - no loading state, no delay
    state = const SimpleAuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
