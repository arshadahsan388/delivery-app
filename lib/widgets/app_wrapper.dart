import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/simple_auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/customer/simple_customer_home_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/rider/rider_home_screen.dart';
import '../models/user_model.dart';

class AppWrapper extends ConsumerWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(simpleAuthProvider);

    // Show loading screen while checking auth state
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If user is not authenticated, show login screen
    if (authState.user == null) {
      return const LoginScreen();
    }

    // If user is authenticated, route to appropriate screen based on role
    final user = authState.user!;
    switch (user.role) {
      case UserRole.admin:
        return const AdminDashboardScreen();
      case UserRole.rider:
        return const RiderHomeScreen();
      case UserRole.customer:
      default:
        return const SimpleCustomerHomeScreen();
    }
  }
}
