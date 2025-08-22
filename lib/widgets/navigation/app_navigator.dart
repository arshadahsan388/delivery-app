import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/simple_auth_provider.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/customer/customer_home_screen.dart';
import '../../screens/rider/rider_dashboard_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../models/user_model.dart';

class AppNavigator extends ConsumerWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(simpleAuthProvider);
    
    // Show loading if authentication is in progress
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // Show login screen if user is not authenticated
    if (authState.user == null) {
      return const LoginScreen();
    }
    
    // Navigate based on user role
    final user = authState.user!;
    switch (user.role) {
      case UserRole.customer:
        return const CustomerHomeScreen();
      case UserRole.rider:
        return const RiderDashboardScreen();
      case UserRole.admin:
        return const AdminDashboardScreen();
    }
  }
}
