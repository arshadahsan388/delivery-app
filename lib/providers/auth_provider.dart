import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  return AuthService.authStateChanges;
});

// Current user data provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  
  return authState.when(
    data: (user) async {
      if (user != null) {
        return await AuthService.getUserData(user.uid);
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Auth controller
class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  AuthController() : super(const AsyncValue.loading()) {
    _initialize();
  }

  void _initialize() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userData = await AuthService.getUserData(user.uid);
        state = AsyncValue.data(userData);
      } catch (e) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await AuthService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        phone: phone,
        role: role,
      );
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await AuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    try {
      await AuthService.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await AuthService.updateUserData(user);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await AuthService.resetPassword(email);
    } catch (e) {
      throw e;
    }
  }
}

// Auth controller provider
final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<UserModel?>>((ref) {
  return AuthController();
});

// Helper providers for checking user roles
final isCustomerProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user.maybeWhen(
    data: (userData) => userData?.role == UserRole.customer,
    orElse: () => false,
  );
});

final isRiderProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user.maybeWhen(
    data: (userData) => userData?.role == UserRole.rider,
    orElse: () => false,
  );
});

final isAdminProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user.maybeWhen(
    data: (userData) => userData?.role == UserRole.admin,
    orElse: () => false,
  );
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});
